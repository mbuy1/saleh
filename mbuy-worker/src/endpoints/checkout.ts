/**
 * Checkout Endpoints - إتمام عملية الشراء
 * 
 * Handles the checkout process from cart to order
 * 
 * @module endpoints/checkout
 */

import { Context } from 'hono';
import { createClient } from '@supabase/supabase-js';
import { Env, AuthContext } from '../types';

type CheckoutContext = Context<{ Bindings: Env; Variables: AuthContext }>;

/**
 * Helper: Get Supabase client with service_role
 */
function getSupabase(env: Env) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });
}

/**
 * Generate unique order number
 */
function generateOrderNumber(): string {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `ORD-${timestamp}-${random}`;
}

// =====================================================
// CHECKOUT OPERATIONS
// =====================================================

/**
 * POST /api/customer/checkout/validate
 * Validate cart before checkout (check stock, prices)
 */
export async function validateCheckout(c: CheckoutContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);

    // Get customer's cart
    const { data: cart } = await supabase
      .from('carts')
      .select('id')
      .eq('user_id', customerId)
      .single();

    if (!cart) {
      return c.json({ ok: false, error: 'EMPTY_CART', message: 'Your cart is empty' }, 400);
    }

    // Get cart items with current product info
    const { data: items, error: itemsError } = await supabase
      .from('cart_items')
      .select(`
        id,
        quantity,
        product_id,
        products (
          id,
          name,
          price,
          stock,
          status,
          store_id,
          stores (id, name, status)
        )
      `)
      .eq('cart_id', cart.id);

    if (itemsError) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: itemsError.message }, 500);
    }

    if (!items || items.length === 0) {
      return c.json({ ok: false, error: 'EMPTY_CART', message: 'Your cart is empty' }, 400);
    }

    const validationErrors: any[] = [];
    const validItems: any[] = [];

    for (const item of items) {
      const product = item.products as any;
      
      if (!product) {
        validationErrors.push({
          item_id: item.id,
          error: 'PRODUCT_NOT_FOUND',
          message: 'Product no longer exists'
        });
        continue;
      }

      if (product.status !== 'active') {
        validationErrors.push({
          item_id: item.id,
          product_name: product.name,
          error: 'PRODUCT_UNAVAILABLE',
          message: 'Product is no longer available'
        });
        continue;
      }

      if (product.stores?.status !== 'active') {
        validationErrors.push({
          item_id: item.id,
          product_name: product.name,
          error: 'STORE_UNAVAILABLE',
          message: 'Store is not available'
        });
        continue;
      }

      if (product.stock < item.quantity) {
        validationErrors.push({
          item_id: item.id,
          product_name: product.name,
          error: 'INSUFFICIENT_STOCK',
          message: `Only ${product.stock} items available`,
          available_stock: product.stock
        });
        continue;
      }

      validItems.push({
        item_id: item.id,
        product_id: product.id,
        product_name: product.name,
        quantity: item.quantity,
        price: product.price,
        subtotal: product.price * item.quantity,
        store_id: product.store_id,
        store_name: product.stores?.name
      });
    }

    const subtotal = validItems.reduce((sum, item) => sum + item.subtotal, 0);
    const isValid = validationErrors.length === 0;

    return c.json({
      ok: true,
      data: {
        is_valid: isValid,
        items: validItems,
        validation_errors: validationErrors,
        summary: {
          subtotal: subtotal,
          items_count: validItems.reduce((sum, item) => sum + item.quantity, 0),
          currency: 'SAR'
        }
      }
    });

  } catch (error: any) {
    console.error('[validateCheckout] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * POST /api/customer/checkout
 * Create order from cart
 */
export async function createOrder(c: CheckoutContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const body = await c.req.json();
    const {
      shipping_address,
      payment_method = 'cash',
      notes = '',
      coupon_code
    } = body;

    if (!shipping_address) {
      return c.json({ ok: false, error: 'MISSING_ADDRESS', message: 'Shipping address is required' }, 400);
    }

    const supabase = getSupabase(c.env);

    // Get cart
    const { data: cart } = await supabase
      .from('carts')
      .select('id')
      .eq('user_id', customerId)
      .single();

    if (!cart) {
      return c.json({ ok: false, error: 'EMPTY_CART', message: 'Your cart is empty' }, 400);
    }

    // Get cart items
    const { data: cartItems, error: itemsError } = await supabase
      .from('cart_items')
      .select(`
        id,
        quantity,
        product_id,
        products (
          id,
          name,
          price,
          stock,
          status,
          image_url,
          main_image_url,
          store_id
        )
      `)
      .eq('cart_id', cart.id);

    if (itemsError || !cartItems || cartItems.length === 0) {
      return c.json({ ok: false, error: 'EMPTY_CART', message: 'Your cart is empty' }, 400);
    }

    // Group items by store
    const storeGroups: Map<string, any[]> = new Map();
    
    for (const item of cartItems) {
      const product = item.products as any;
      
      if (!product || product.status !== 'active') continue;
      if (product.stock < item.quantity) {
        return c.json({
          ok: false,
          error: 'INSUFFICIENT_STOCK',
          message: `Insufficient stock for ${product.name}. Only ${product.stock} available.`
        }, 400);
      }

      const storeId = product.store_id;
      if (!storeGroups.has(storeId)) {
        storeGroups.set(storeId, []);
      }
      storeGroups.get(storeId)!.push({
        ...item,
        product
      });
    }

    if (storeGroups.size === 0) {
      return c.json({ ok: false, error: 'NO_VALID_ITEMS', message: 'No valid items in cart' }, 400);
    }

    // Calculate totals
    const orders: any[] = [];
    let totalAmount = 0;

    // Create orders for each store
    for (const [storeId, items] of storeGroups) {
      const subtotal = items.reduce((sum, item) => sum + (item.product.price * item.quantity), 0);
      const shippingAmount = 25; // Fixed shipping per store (configurable)
      const orderTotal = subtotal + shippingAmount;
      totalAmount += orderTotal;

      const orderNumber = generateOrderNumber();

      // Create order
      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
          order_number: orderNumber,
          customer_id: customerId,
          store_id: storeId,
          status: 'pending',
          payment_status: payment_method === 'cash' ? 'pending' : 'pending',
          payment_method: payment_method,
          subtotal: subtotal,
          discount_amount: 0,
          tax_amount: 0,
          shipping_amount: shippingAmount,
          total_amount: orderTotal,
          shipping_address: shipping_address,
          notes: notes,
          coupon_code: coupon_code || null
        })
        .select('id, order_number')
        .single();

      if (orderError) {
        console.error('[createOrder] Error creating order:', orderError);
        return c.json({ ok: false, error: 'ORDER_CREATION_FAILED', message: orderError.message }, 500);
      }

      // Create order items
      const orderItems = items.map(item => ({
        order_id: order.id,
        product_id: item.product.id,
        product_name: item.product.name,
        product_image_url: item.product.main_image_url || item.product.image_url,
        quantity: item.quantity,
        price: item.product.price,
        total: item.product.price * item.quantity
      }));

      const { error: itemsInsertError } = await supabase
        .from('order_items')
        .insert(orderItems);

      if (itemsInsertError) {
        console.error('[createOrder] Error creating order items:', itemsInsertError);
        // Rollback order
        await supabase.from('orders').delete().eq('id', order.id);
        return c.json({ ok: false, error: 'ORDER_ITEMS_FAILED', message: itemsInsertError.message }, 500);
      }

      // Update product stock
      for (const item of items) {
        const newStock = item.product.stock - item.quantity;
        await supabase
          .from('products')
          .update({ stock: newStock })
          .eq('id', item.product.id);
      }

      orders.push({
        id: order.id,
        order_number: order.order_number,
        store_id: storeId,
        subtotal: subtotal,
        shipping: shippingAmount,
        total: orderTotal,
        items_count: items.reduce((sum: number, item: any) => sum + item.quantity, 0)
      });
    }

    // Clear cart after successful order
    await supabase
      .from('cart_items')
      .delete()
      .eq('cart_id', cart.id);

    return c.json({
      ok: true,
      message: 'Order placed successfully',
      data: {
        orders: orders,
        total_amount: totalAmount,
        payment_method: payment_method,
        shipping_address: shipping_address
      }
    }, 201);

  } catch (error: any) {
    console.error('[createOrder] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/orders
 * Get customer's orders
 */
export async function getCustomerOrders(c: CheckoutContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);
    
    const page = parseInt(c.req.query('page') || '1');
    const limit = parseInt(c.req.query('limit') || '20');
    const status = c.req.query('status');
    const offset = (page - 1) * limit;

    let query = supabase
      .from('orders')
      .select(`
        id,
        order_number,
        status,
        payment_status,
        payment_method,
        subtotal,
        discount_amount,
        shipping_amount,
        total_amount,
        shipping_address,
        created_at,
        stores (id, name, logo_url),
        order_items (
          id,
          product_name,
          product_image_url,
          quantity,
          price,
          total
        )
      `, { count: 'exact' })
      .eq('customer_id', customerId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (status) {
      query = query.eq('status', status);
    }

    const { data, error, count } = await query;

    if (error) {
      console.error('[getCustomerOrders] Error:', error);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    return c.json({
      ok: true,
      data: data || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit)
      }
    });

  } catch (error: any) {
    console.error('[getCustomerOrders] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/orders/:id
 * Get single order details
 */
export async function getOrderDetails(c: CheckoutContext) {
  const customerId = c.get('userId');
  const orderId = c.req.param('id');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!orderId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Order ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    const { data: order, error } = await supabase
      .from('orders')
      .select(`
        id,
        order_number,
        status,
        payment_status,
        payment_method,
        subtotal,
        discount_amount,
        tax_amount,
        shipping_amount,
        total_amount,
        shipping_address,
        notes,
        coupon_code,
        created_at,
        updated_at,
        stores (id, name, logo_url, phone),
        order_items (
          id,
          product_id,
          product_name,
          product_image_url,
          quantity,
          price,
          total
        )
      `)
      .eq('id', orderId)
      .eq('customer_id', customerId)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return c.json({ ok: false, error: 'ORDER_NOT_FOUND', message: 'Order not found' }, 404);
      }
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    return c.json({ ok: true, data: order });

  } catch (error: any) {
    console.error('[getOrderDetails] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * POST /api/customer/orders/:id/cancel
 * Cancel an order (only if pending)
 */
export async function cancelOrder(c: CheckoutContext) {
  const customerId = c.get('userId');
  const orderId = c.req.param('id');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!orderId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Order ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    // Get order
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .select('id, status, order_items(product_id, quantity)')
      .eq('id', orderId)
      .eq('customer_id', customerId)
      .single();

    if (orderError || !order) {
      return c.json({ ok: false, error: 'ORDER_NOT_FOUND', message: 'Order not found' }, 404);
    }

    if (order.status !== 'pending') {
      return c.json({
        ok: false,
        error: 'CANNOT_CANCEL',
        message: 'Only pending orders can be cancelled'
      }, 400);
    }

    // Restore stock
    for (const item of (order.order_items as any[])) {
      const { data: product } = await supabase
        .from('products')
        .select('stock')
        .eq('id', item.product_id)
        .single();

      if (product) {
        await supabase
          .from('products')
          .update({ stock: product.stock + item.quantity })
          .eq('id', item.product_id);
      }
    }

    // Update order status
    const { error: updateError } = await supabase
      .from('orders')
      .update({ status: 'cancelled' })
      .eq('id', orderId);

    if (updateError) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: updateError.message }, 500);
    }

    return c.json({ ok: true, message: 'Order cancelled successfully' });

  } catch (error: any) {
    console.error('[cancelOrder] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/addresses
 * Get customer's saved addresses
 */
export async function getAddresses(c: CheckoutContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);

    // Check if customer_addresses table exists, if not use user_profiles
    const { data: addresses, error } = await supabase
      .from('customer_addresses')
      .select('*')
      .eq('customer_id', customerId)
      .order('is_default', { ascending: false });

    if (error) {
      // Table might not exist, return empty array
      console.log('[getAddresses] Table may not exist:', error.message);
      return c.json({ ok: true, data: [] });
    }

    return c.json({ ok: true, data: addresses || [] });

  } catch (error: any) {
    console.error('[getAddresses] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}
