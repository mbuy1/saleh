/**
 * MBUY Edge Function: points_add
 * Adds points to user account with transaction logging
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface PointsAddRequest {
  user_id: string;
  points: number;
  reason: string; // 'purchase', 'bonus', 'refund', 'signup', etc.
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
    const body: PointsAddRequest = await req.json();
    const { user_id, points, reason, meta } = body;

    // Validate input
    if (!user_id || !points || !reason) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing required fields: user_id, points, reason' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (points === 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Points must be non-zero' }),
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

    // Get or create points account
    let { data: account, error: accountError } = await supabase
      .from('points_accounts')
      .select('*')
      .eq('user_id', user_id)
      .single();

    if (accountError && accountError.code !== 'PGRST116') {
      throw accountError;
    }

    if (!account) {
      // Create points account
      const { data: newAccount, error: createError } = await supabase
        .from('points_accounts')
        .insert({
          user_id: user_id,
          points_balance: 0,
        })
        .select()
        .single();

      if (createError) throw createError;
      account = newAccount;
    }

    // Calculate new balance
    const currentBalance = parseInt(account.points_balance.toString());
    const newBalance = currentBalance + points;

    // Check if balance would go negative
    if (newBalance < 0) {
      return new Response(
        JSON.stringify({ error: 'Insufficient points', detail: `Cannot deduct ${Math.abs(points)} points. Current balance: ${currentBalance}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Update points balance
    const { error: updateError } = await supabase
      .from('points_accounts')
      .update({ points_balance: newBalance })
      .eq('id', account.id);

    if (updateError) throw updateError;

    // Create transaction record
    const { data: transaction, error: transactionError } = await supabase
      .from('points_transactions')
      .insert({
        points_account_id: account.id,
        points: points,
        type: points > 0 ? 'earn' : 'spend',
        reason: reason,
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
          const title = points > 0 ? 'تم إضافة نقاط' : 'تم خصم نقاط';
          const body = points > 0 
            ? `تم إضافة ${points} نقطة إلى حسابك`
            : `تم خصم ${Math.abs(points)} نقطة من حسابك`;

          await fetch('https://fcm.googleapis.com/fcm/send', {
            method: 'POST',
            headers: {
              'Authorization': `key=${firebaseKey}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              to: profile.fcm_token,
              notification: { title, body },
              data: {
                type: 'points_change',
                points: points.toString(),
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
          account_id: account.id,
          transaction_id: transaction.id,
          old_balance: currentBalance,
          new_balance: newBalance,
          points_changed: points,
        },
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in points_add:', error);
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
