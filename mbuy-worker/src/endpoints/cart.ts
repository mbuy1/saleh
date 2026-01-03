/**
 * Cart Endpoints - إدارة سلة التسوق للعميل
 * 
 * Endpoints for customer shopping cart management
 * 
 * @module endpoints/cart
 */

import { Context } from 'hono';
import { createClient } from '@supabase/supabase-js';
import { Env, AuthContext } from '../types';

type CartContext = Context<{ Bindings: Env; Variables: AuthContext }>;

/**
 * Helper: Get Supabase client with service_role
 */
function getSupabase(env: Env) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });
}

// =====================================================
// CART OPERATIONS
// =====================================================

/**
 * GET /api/customer/cart
 * Get customer's cart with all items
 */
export async function getCart(c: CartContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);
    
    // Get or create cart for customer
    let { data: cart, error: cartError } = await supabase
      .from('carts')
      .select('id')
      .eq('user_id', customerId)
      .single();

    if (cartError && cartError.code !== 'PGRST116') {
      console.error('[getCart] Error fetching cart:', cartError);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: cartError.message }, 500);
    }

    // Create cart if doesn't exist
    if (!cart) {
      const { data: newCart, error: createError } = await supabase
        .from('carts')
        .insert({ user_id: customerId })
        .select('id')
        .single();

      if (createError) {
        console.error('[getCart] Error creating cart:', createError);
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: createError.message }, 500);
      }
      cart = newCart;
    }

    // Get cart items with product details
    const { data: items, error: itemsError } = await supabase
      .from('cart_items')
      .select(`
        id,
        quantity,
        added_at,
        products (
          id,
          name,
          description,
          price,
          compare_at_price,
          stock,
          image_url,
          main_image_url,
          status,
          stores (
            id,
            name,
            logo_url
          )
        )
      `)
      .eq('cart_id', cart.id)
      .order('added_at', { ascending: false });

    if (itemsError) {
      console.error('[getCart] Error fetching items:', itemsError);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: itemsError.message }, 500);
    }

    // Calculate totals
    const cartItems = (items || []).map((item: any) => ({
      id: item.id,
      quantity: item.quantity,
      added_at: item.added_at,
      product: item.products ? {
        id: item.products.id,
        name: item.products.name,
        description: item.products.description,
        price: item.products.price,
        compare_at_price: item.products.compare_at_price,
        stock: item.products.stock,
        image_url: item.products.main_image_url || item.products.image_url,
        status: item.products.status,
        store: item.products.stores
      } : null
    })).filter((item: any) => item.product !== null);

    const subtotal = cartItems.reduce((sum: number, item: any) => 
      sum + (item.product.price * item.quantity), 0);
    
    const itemsCount = cartItems.reduce((sum: number, item: any) => sum + item.quantity, 0);

    return c.json({
      ok: true,
      data: {
        cart_id: cart.id,
        items: cartItems,
        items_count: itemsCount,
        subtotal: subtotal,
        currency: 'SAR'
      }
    });

  } catch (error: any) {
    console.error('[getCart] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * POST /api/customer/cart/items
 * Add item to cart
 */
export async function addToCart(c: CartContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const body = await c.req.json();
    const { product_id, quantity = 1 } = body;

    if (!product_id) {
      return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Product ID is required' }, 400);
    }

    if (quantity < 1) {
      return c.json({ ok: false, error: 'INVALID_QUANTITY', message: 'Quantity must be at least 1' }, 400);
    }

    const supabase = getSupabase(c.env);

    // Verify product exists and is available
    const { data: product, error: productError } = await supabase
      .from('products')
      .select('id, name, price, stock, status')
      .eq('id', product_id)
      .single();

    if (productError || !product) {
      return c.json({ ok: false, error: 'PRODUCT_NOT_FOUND', message: 'Product not found' }, 404);
    }

    if (product.status !== 'active') {
      return c.json({ ok: false, error: 'PRODUCT_UNAVAILABLE', message: 'Product is not available' }, 400);
    }

    if (product.stock < quantity) {
      return c.json({ ok: false, error: 'INSUFFICIENT_STOCK', message: `Only ${product.stock} items available` }, 400);
    }

    // Get or create cart
    let { data: cart } = await supabase
      .from('carts')
      .select('id')
      .eq('user_id', customerId)
      .single();

    if (!cart) {
      const { data: newCart, error: createError } = await supabase
        .from('carts')
        .insert({ user_id: customerId })
        .select('id')
        .single();

      if (createError) {
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: createError.message }, 500);
      }
      cart = newCart;
    }

    // Check if product already in cart
    const { data: existingItem } = await supabase
      .from('cart_items')
      .select('id, quantity')
      .eq('cart_id', cart.id)
      .eq('product_id', product_id)
      .single();

    if (existingItem) {
      // Update quantity
      const newQuantity = existingItem.quantity + quantity;
      
      if (newQuantity > product.stock) {
        return c.json({ 
          ok: false, 
          error: 'INSUFFICIENT_STOCK', 
          message: `Cannot add more. Only ${product.stock} items available` 
        }, 400);
      }

      const { error: updateError } = await supabase
        .from('cart_items')
        .update({ quantity: newQuantity })
        .eq('id', existingItem.id);

      if (updateError) {
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: updateError.message }, 500);
      }

      return c.json({ 
        ok: true, 
        message: 'Cart updated', 
        data: { item_id: existingItem.id, quantity: newQuantity } 
      });
    } else {
      // Add new item
      const { data: newItem, error: insertError } = await supabase
        .from('cart_items')
        .insert({
          cart_id: cart.id,
          product_id: product_id,
          quantity: quantity
        })
        .select('id')
        .single();

      if (insertError) {
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: insertError.message }, 500);
      }

      return c.json({ 
        ok: true, 
        message: 'Item added to cart', 
        data: { item_id: newItem.id, quantity: quantity } 
      }, 201);
    }

  } catch (error: any) {
    console.error('[addToCart] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * PATCH /api/customer/cart/items/:id
 * Update cart item quantity
 */
export async function updateCartItem(c: CartContext) {
  const customerId = c.get('userId');
  const itemId = c.req.param('id');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!itemId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Item ID is required' }, 400);
  }

  try {
    const body = await c.req.json();
    const { quantity } = body;

    if (typeof quantity !== 'number' || quantity < 0) {
      return c.json({ ok: false, error: 'INVALID_QUANTITY', message: 'Valid quantity is required' }, 400);
    }

    const supabase = getSupabase(c.env);

    // Verify item belongs to customer's cart
    const { data: item, error: itemError } = await supabase
      .from('cart_items')
      .select(`
        id,
        quantity,
        product_id,
        carts!inner (user_id),
        products (stock)
      `)
      .eq('id', itemId)
      .single();

    if (itemError || !item) {
      return c.json({ ok: false, error: 'ITEM_NOT_FOUND', message: 'Cart item not found' }, 404);
    }

    if ((item.carts as any).user_id !== customerId) {
      return c.json({ ok: false, error: 'FORBIDDEN', message: 'Access denied' }, 403);
    }

    if (quantity === 0) {
      // Remove item
      const { error: deleteError } = await supabase
        .from('cart_items')
        .delete()
        .eq('id', itemId);

      if (deleteError) {
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: deleteError.message }, 500);
      }

      return c.json({ ok: true, message: 'Item removed from cart' });
    }

    // Check stock
    if ((item.products as any).stock < quantity) {
      return c.json({ 
        ok: false, 
        error: 'INSUFFICIENT_STOCK', 
        message: `Only ${(item.products as any).stock} items available` 
      }, 400);
    }

    // Update quantity
    const { error: updateError } = await supabase
      .from('cart_items')
      .update({ quantity: quantity })
      .eq('id', itemId);

    if (updateError) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: updateError.message }, 500);
    }

    return c.json({ ok: true, message: 'Cart updated', data: { quantity } });

  } catch (error: any) {
    console.error('[updateCartItem] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * DELETE /api/customer/cart/items/:id
 * Remove item from cart
 */
export async function removeFromCart(c: CartContext) {
  const customerId = c.get('userId');
  const itemId = c.req.param('id');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!itemId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Item ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    // Verify item belongs to customer's cart
    const { data: item, error: itemError } = await supabase
      .from('cart_items')
      .select(`
        id,
        carts!inner (user_id)
      `)
      .eq('id', itemId)
      .single();

    if (itemError || !item) {
      return c.json({ ok: false, error: 'ITEM_NOT_FOUND', message: 'Cart item not found' }, 404);
    }

    if ((item.carts as any).user_id !== customerId) {
      return c.json({ ok: false, error: 'FORBIDDEN', message: 'Access denied' }, 403);
    }

    // Delete item
    const { error: deleteError } = await supabase
      .from('cart_items')
      .delete()
      .eq('id', itemId);

    if (deleteError) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: deleteError.message }, 500);
    }

    return c.json({ ok: true, message: 'Item removed from cart' });

  } catch (error: any) {
    console.error('[removeFromCart] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * DELETE /api/customer/cart
 * Clear entire cart
 */
export async function clearCart(c: CartContext) {
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
      return c.json({ ok: true, message: 'Cart is already empty' });
    }

    // Delete all cart items
    const { error: deleteError } = await supabase
      .from('cart_items')
      .delete()
      .eq('cart_id', cart.id);

    if (deleteError) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: deleteError.message }, 500);
    }

    return c.json({ ok: true, message: 'Cart cleared successfully' });

  } catch (error: any) {
    console.error('[clearCart] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/cart/count
 * Get cart items count (for badge)
 */
export async function getCartCount(c: CartContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);

    const { data: cart } = await supabase
      .from('carts')
      .select('id')
      .eq('user_id', customerId)
      .single();

    if (!cart) {
      return c.json({ ok: true, data: { count: 0 } });
    }

    const { data: items, error } = await supabase
      .from('cart_items')
      .select('quantity')
      .eq('cart_id', cart.id);

    if (error) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    const count = (items || []).reduce((sum, item) => sum + item.quantity, 0);

    return c.json({ ok: true, data: { count } });

  } catch (error: any) {
    console.error('[getCartCount] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}
