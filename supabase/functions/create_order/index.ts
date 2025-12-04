/**
 * MBUY Edge Function: create_order
 * Creates an order with payment processing, points/wallet handling, and notifications
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

// CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface OrderItem {
  product_id: string;
  quantity: number;
  price?: number; // Optional, will fetch from DB if not provided
}

interface CreateOrderRequest {
  user_id: string;
  items: OrderItem[];
  payment_method: 'cash' | 'card' | 'wallet' | 'tap' | 'hyperpay' | 'tamara' | 'tabby';
  shipping_address_id?: string;
  use_points?: number; // Points to use as discount
  coupon_code?: string;
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
    const body: CreateOrderRequest = await req.json();
    const { user_id, items, payment_method, shipping_address_id, use_points, coupon_code, meta } = body;

    // Enhanced input validation
    const missingFields = [];
    if (!user_id) missingFields.push('user_id');
    if (!items || !Array.isArray(items)) missingFields.push('items');
    if (!payment_method) missingFields.push('payment_method');

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

    // Validate items array
    if (items.length === 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Items array cannot be empty' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (items.length > 50) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Maximum 50 items per order' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Validate each item
    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      if (!item.product_id) {
        return new Response(
          JSON.stringify({ error: 'Bad request', detail: `Item ${i + 1}: Missing product_id` }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
      if (typeof item.quantity !== 'number' || item.quantity <= 0 || item.quantity > 1000) {
        return new Response(
          JSON.stringify({ error: 'Bad request', detail: `Item ${i + 1}: Invalid quantity (must be 1-1000)` }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
    }

    // Validate payment method
    const validPaymentMethods = ['cash', 'card', 'wallet', 'tap', 'hyperpay', 'tamara', 'tabby'];
    if (!validPaymentMethods.includes(payment_method.toLowerCase())) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: `Invalid payment method. Must be one of: ${validPaymentMethods.join(', ')}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Validate use_points if provided
    if (use_points !== undefined && use_points !== null) {
      if (typeof use_points !== 'number' || use_points < 0 || !Number.isInteger(use_points)) {
        return new Response(
          JSON.stringify({ error: 'Bad request', detail: 'use_points must be a non-negative integer' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
    }

    // Validate coupon_code if provided
    if (coupon_code !== undefined && coupon_code !== null) {
      if (typeof coupon_code !== 'string' || coupon_code.trim().length === 0) {
        return new Response(
          JSON.stringify({ error: 'Bad request', detail: 'coupon_code must be a non-empty string' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
    }

    // Create Supabase admin client
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || Deno.env.get('SB_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SB_SERVICE_ROLE_KEY');
    
    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Missing Supabase environment variables');
    }

    const supabase = createClient(
      supabaseUrl,
      supabaseServiceKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    // ========== 1. Fetch product details and calculate total ==========
    const productIds = items.map(item => item.product_id);
    const { data: products, error: productsError } = await supabase
      .from('products')
      .select('id, name, price, stock_quantity, store_id')
      .in('id', productIds);

    if (productsError) throw productsError;

    // Validate stock and calculate total
    let subtotal = 0;
    const orderItemsData = [];

    for (const item of items) {
      const product = products?.find((p: any) => p.id === item.product_id);
      if (!product) {
        return new Response(
          JSON.stringify({ error: 'Product not found', detail: `Product ${item.product_id} not found` }),
          { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Check stock
      if (product.stock_quantity < item.quantity) {
        return new Response(
          JSON.stringify({ error: 'Insufficient stock', detail: `Product ${product.name} has only ${product.stock_quantity} in stock` }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const price = item.price || product.price;
      const itemTotal = price * item.quantity;
      subtotal += itemTotal;

      orderItemsData.push({
        product_id: product.id,
        product_name: product.name,
        quantity: item.quantity,
        price: price,
        store_id: product.store_id,
      });
    }

    // ========== 2. Apply points discount if requested ==========
    let pointsDiscount = 0;
    let pointsUsed = 0;
    if (use_points && use_points > 0) {
      const { data: pointsAccount } = await supabase
        .from('points_accounts')
        .select('points_balance')
        .eq('user_id', user_id)
        .single();

      if (pointsAccount) {
        const availablePoints = parseInt(pointsAccount.points_balance.toString());
        pointsUsed = Math.min(use_points, availablePoints);
        // 1 point = 0.1 SAR
        pointsDiscount = pointsUsed * 0.1;
      }
    }

    // ========== 3. Apply coupon discount if provided ==========
    let couponDiscount = 0;
    if (coupon_code) {
      const { data: coupon } = await supabase
        .from('coupons')
        .select('*')
        .eq('code', coupon_code)
        .eq('is_active', true)
        .single();

      if (coupon) {
        // Check expiry
        if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) {
          // Coupon expired, skip
        } else if (coupon.discount_type === 'percent') {
          couponDiscount = (subtotal * coupon.discount_value) / 100;
          if (coupon.max_discount_amount) {
            couponDiscount = Math.min(couponDiscount, coupon.max_discount_amount);
          }
        } else {
          couponDiscount = coupon.discount_value;
        }
      }
    }

    // ========== 4. Calculate final total ==========
    const shipping_fee = 15; // Fixed shipping fee
    const total_amount = Math.max(0, subtotal - pointsDiscount - couponDiscount + shipping_fee);

    // ========== 5. Process payment ==========
    let payment_status = 'pending';
    let payment_reference = null;

    if (payment_method === 'wallet') {
      // Deduct from wallet
      const { data: wallet } = await supabase
        .from('wallets')
        .select('id, balance')
        .eq('owner_id', user_id)
        .eq('type', 'customer')
        .single();

      if (!wallet) {
        return new Response(
          JSON.stringify({ error: 'Wallet not found' }),
          { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const currentBalance = parseFloat(wallet.balance.toString());
      if (currentBalance < total_amount) {
        return new Response(
          JSON.stringify({ error: 'Insufficient wallet balance', detail: `Required: ${total_amount}, Available: ${currentBalance}` }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Deduct from wallet
      const { error: walletError } = await supabase
        .from('wallets')
        .update({ balance: currentBalance - total_amount })
        .eq('id', wallet.id);

      if (walletError) throw walletError;

      // Log transaction
      await supabase
        .from('wallet_transactions')
        .insert({
          wallet_id: wallet.id,
          amount: -total_amount,
          type: 'withdraw',
          source: 'order_payment',
          balance_after: currentBalance - total_amount,
        });

      payment_status = 'paid';
    } else if (payment_method === 'tap' || payment_method === 'hyperpay') {
      // Payment gateway integration (placeholder)
      // In production, call payment API here
      const paymentKey = Deno.env.get(`PAYMENT_${payment_method.toUpperCase()}_API_KEY`);
      if (paymentKey) {
        // TODO: Integrate with payment gateway
        payment_reference = `${payment_method}_${Date.now()}`;
        payment_status = 'pending'; // Will be updated via webhook
      }
    } else if (payment_method === 'cash') {
      payment_status = 'pending';
    }

    // ========== 6. Create order ==========
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .insert({
        customer_id: user_id,
        total_amount: total_amount,
        subtotal: subtotal,
        shipping_fee: shipping_fee,
        discount_amount: pointsDiscount + couponDiscount,
        status: 'pending',
        payment_method: payment_method,
        payment_status: payment_status,
        payment_reference: payment_reference,
        shipping_address_id: shipping_address_id,
      })
      .select()
      .single();

    if (orderError) throw orderError;

    // ========== 7. Create order items and update stock ==========
    for (const item of orderItemsData) {
      await supabase
        .from('order_items')
        .insert({
          order_id: order.id,
          product_id: item.product_id,
          quantity: item.quantity,
          price: item.price,
        });

      // Update stock
      await supabase.rpc('decrement_stock', {
        product_id: item.product_id,
        quantity: item.quantity,
      });
    }

    // ========== 8. Deduct points if used ==========
    if (pointsUsed > 0) {
      const { data: pointsAccount } = await supabase
        .from('points_accounts')
        .select('id, points_balance')
        .eq('user_id', user_id)
        .single();

      if (pointsAccount) {
        const newBalance = parseInt(pointsAccount.points_balance.toString()) - pointsUsed;
        await supabase
          .from('points_accounts')
          .update({ points_balance: newBalance })
          .eq('id', pointsAccount.id);

        await supabase
          .from('points_transactions')
          .insert({
            points_account_id: pointsAccount.id,
            points: -pointsUsed,
            type: 'spend',
            reason: 'order_discount',
            meta: { order_id: order.id },
            balance_after: newBalance,
          });
      }
    }

    // ========== 9. Award points for purchase (1% of subtotal) ==========
    const earnedPoints = Math.floor(subtotal * 0.01);
    if (earnedPoints > 0) {
      const { data: pointsAccount } = await supabase
        .from('points_accounts')
        .select('id, points_balance')
        .eq('user_id', user_id)
        .single();

      if (pointsAccount) {
        const newBalance = parseInt(pointsAccount.points_balance.toString()) + earnedPoints;
        await supabase
          .from('points_accounts')
          .update({ points_balance: newBalance })
          .eq('id', pointsAccount.id);

        await supabase
          .from('points_transactions')
          .insert({
            points_account_id: pointsAccount.id,
            points: earnedPoints,
            type: 'earn',
            reason: 'purchase_reward',
            meta: { order_id: order.id },
            balance_after: newBalance,
          });
      }
    }

    // ========== 10. Send FCM notifications ==========
    const firebaseKey = Deno.env.get('FIREBASE_SERVER_KEY');
    if (firebaseKey) {
      try {
        // Get customer's device token
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
                title: 'تم إنشاء الطلب بنجاح',
                body: `رقم الطلب: ${order.id} - المبلغ: ${total_amount} ر.س`,
              },
              data: {
                type: 'order_created',
                order_id: order.id,
              },
            }),
          });
        }

        // Notify merchants
        const storeIds = [...new Set(orderItemsData.map(item => item.store_id))];
        for (const storeId of storeIds) {
          const { data: store } = await supabase
            .from('stores')
            .select('owner_id')
            .eq('id', storeId)
            .single();

          if (store) {
            const { data: merchantProfile } = await supabase
              .from('user_profiles')
              .select('fcm_token')
              .eq('id', store.owner_id)
              .single();

            if (merchantProfile?.fcm_token) {
              await fetch('https://fcm.googleapis.com/fcm/send', {
                method: 'POST',
                headers: {
                  'Authorization': `key=${firebaseKey}`,
                  'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                  to: merchantProfile.fcm_token,
                  notification: {
                    title: 'طلب جديد',
                    body: `لديك طلب جديد رقم ${order.id}`,
                  },
                  data: {
                    type: 'new_order',
                    order_id: order.id,
                  },
                }),
              });
            }
          }
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
          order_id: order.id,
          total_amount: total_amount,
          payment_status: payment_status,
          payment_reference: payment_reference,
          points_used: pointsUsed,
          points_earned: earnedPoints,
          discount_applied: pointsDiscount + couponDiscount,
        },
      }),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in create_order:', error);
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
