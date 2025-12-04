/**
 * MBUY Edge Function: merchant_register
 * Registers a new merchant and creates their store
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface MerchantRegisterRequest {
  user_id: string;
  store_name: string;
  store_description?: string;
  city?: string;
  plan_id?: string;
  meta?: Record<string, any>;
}

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // Verify internal key
    const internalKey = req.headers.get('x-internal-key');
    if (!internalKey || internalKey !== Deno.env.get('EDGE_INTERNAL_KEY')) {
      return new Response(
        JSON.stringify({ error: 'Forbidden', detail: 'Invalid internal key' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Parse request body
    const body: MerchantRegisterRequest = await req.json();
    const { user_id, store_name, store_description, city, plan_id, meta } = body;

    // Validate input
    if (!user_id || !store_name) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing required fields: user_id, store_name' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Create Supabase admin client
    const supabase = createClient(
      Deno.env.get('SB_URL') ?? '',
      Deno.env.get('SB_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    // Check if user already has a store
    const { data: existingStore, error: checkError } = await supabase
      .from('stores')
      .select('id')
      .eq('owner_id', user_id)
      .single();

    if (existingStore) {
      return new Response(
        JSON.stringify({ error: 'Conflict', detail: 'User already has a store' }),
        { status: 409, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Create store
    const { data: store, error: storeError } = await supabase
      .from('stores')
      .insert({
        owner_id: user_id,
        name: store_name,
        description: store_description || '',
        city: city || null,
        is_active: true,
        is_verified: false,
        rating: 0,
        followers_count: 0,
      })
      .select()
      .single();

    if (storeError) throw storeError;

    // Update user profile role to merchant
    const { error: profileError } = await supabase
      .from('user_profiles')
      .update({ role: 'merchant' })
      .eq('id', user_id);

    if (profileError) {
      // If profile doesn't exist, create it
      const { error: createProfileError } = await supabase
        .from('user_profiles')
        .insert({
          id: user_id,
          role: 'merchant',
        });

      if (createProfileError) throw createProfileError;
    }

    // Create merchant wallet
    const { data: wallet, error: walletError } = await supabase
      .from('wallets')
      .insert({
        owner_id: user_id,
        type: 'merchant',
        balance: 0,
      })
      .select()
      .single();

    if (walletError && walletError.code !== '23505') {
      // Ignore duplicate key error
      throw walletError;
    }

    // Create merchant points account
    const { data: pointsAccount, error: pointsError } = await supabase
      .from('points_accounts')
      .insert({
        user_id: user_id,
        points_balance: 100, // Welcome bonus
      })
      .select()
      .single();

    if (pointsError && pointsError.code !== '23505') {
      // Ignore duplicate key error
      throw pointsError;
    }

    // If welcome bonus was added, log it
    if (pointsAccount) {
      await supabase
        .from('points_transactions')
        .insert({
          points_account_id: pointsAccount.id,
          points: 100,
          type: 'earn',
          reason: 'merchant_signup_bonus',
          balance_after: 100,
        });
    }

    // Send FCM notification if configured
    const firebaseKey = Deno.env.get('FIREBASE_SERVER_KEY');
    if (firebaseKey) {
      try {
        // Get user's device token
        const { data: profile } = await supabase
          .from('user_profiles')
          .select('fcm_token')
          .eq('id', user_id)
          .single();

        if (profile?.fcm_token) {
          await fetch('https://fcm.googleapis.com/fcm/send', {
            method: 'POST',
            headers: {
              'Authorization': `key=${firebaseKey}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              to: profile.fcm_token,
              notification: {
                title: 'مرحباً بك كتاجر!',
                body: `تم إنشاء متجرك "${store_name}" بنجاح. حصلت على 100 نقطة كمكافأة ترحيبية!`,
              },
              data: {
                type: 'merchant_registered',
                store_id: store.id,
              },
            }),
          });
        }
      } catch (fcmError) {
        console.error('FCM notification failed:', fcmError);
        // Don't fail the request if notification fails
      }
    }

    return new Response(
      JSON.stringify({
        ok: true,
        data: {
          store_id: store.id,
          store_name: store.name,
          wallet_id: wallet?.id,
          points_account_id: pointsAccount?.id,
          welcome_bonus: 100,
        },
      }),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in merchant_register:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
    return new Response(
      JSON.stringify({
        error: 'Internal server error',
        detail: errorMessage,
      }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
