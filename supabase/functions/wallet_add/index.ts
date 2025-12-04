/**
 * MBUY Edge Function: wallet_add
 * Adds funds to user wallet with transaction logging
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface WalletAddRequest {
  user_id: string;
  amount: number;
  source: string; // 'payment', 'refund', 'bonus', etc.
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
    const body: WalletAddRequest = await req.json();
    const { user_id, amount, source, meta } = body;

    // Enhanced input validation
    const missingFields = [];
    if (!user_id) missingFields.push('user_id');
    if (amount === undefined || amount === null) missingFields.push('amount');
    if (!source) missingFields.push('source');

    if (missingFields.length > 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: `Missing required fields: ${missingFields.join(', ')}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Validate UUID format
    if (typeof user_id !== 'string' || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(user_id)) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Invalid user_id format' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Validate amount
    if (typeof amount !== 'number' || isNaN(amount) || amount <= 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Amount must be a positive number' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (amount > 1000000) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Amount exceeds maximum limit (1,000,000)' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Validate source
    if (typeof source !== 'string' || source.trim().length === 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Source must be a non-empty string' }),
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

    // Get or create wallet
    let { data: wallet, error: walletError } = await supabase
      .from('wallets')
      .select('*')
      .eq('owner_id', user_id)
      .eq('type', 'customer')
      .single();

    if (walletError && walletError.code !== 'PGRST116') {
      throw walletError;
    }

    if (!wallet) {
      // Create wallet
      const { data: newWallet, error: createError } = await supabase
        .from('wallets')
        .insert({
          owner_id: user_id,
          type: 'customer',
          balance: 0,
        })
        .select()
        .single();

      if (createError) throw createError;
      wallet = newWallet;
    }

    // Calculate new balance
    const currentBalance = parseFloat(wallet.balance.toString());
    const newBalance = currentBalance + amount;

    // Update wallet balance
    const { error: updateError } = await supabase
      .from('wallets')
      .update({ balance: newBalance })
      .eq('id', wallet.id);

    if (updateError) throw updateError;

    // Create transaction record
    const { data: transaction, error: transactionError } = await supabase
      .from('wallet_transactions')
      .insert({
        wallet_id: wallet.id,
        amount: amount,
        type: 'deposit',
        source: source,
        meta: meta || {},
        balance_after: newBalance,
      })
      .select()
      .single();

    if (transactionError) throw transactionError;

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
                title: 'تم إضافة رصيد',
                body: `تم إضافة ${amount} ر.س إلى محفظتك`,
              },
              data: {
                type: 'wallet_add',
                amount: amount.toString(),
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
          wallet_id: wallet.id,
          transaction_id: transaction.id,
          old_balance: currentBalance,
          new_balance: newBalance,
          amount_added: amount,
        },
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in wallet_add:', error);
    return new Response(
      JSON.stringify({
        error: 'Internal server error',
        detail: error.message,
      }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
