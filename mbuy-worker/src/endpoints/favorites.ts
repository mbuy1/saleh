/**
 * Favorites Endpoints - إدارة المفضلة للعميل
 * 
 * Endpoints for customer favorites/wishlist management
 * 
 * @module endpoints/favorites
 */

import { Context } from 'hono';
import { createClient } from '@supabase/supabase-js';
import { Env, AuthContext } from '../types';

type FavoritesContext = Context<{ Bindings: Env; Variables: AuthContext }>;

/**
 * Helper: Get Supabase client with service_role
 */
function getSupabase(env: Env) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });
}

// =====================================================
// FAVORITES OPERATIONS
// =====================================================

/**
 * GET /api/customer/favorites
 * Get customer's favorites list with product details
 */
export async function getFavorites(c: FavoritesContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);
    
    const page = parseInt(c.req.query('page') || '1');
    const limit = parseInt(c.req.query('limit') || '20');
    const offset = (page - 1) * limit;

    // Get favorites with product details
    const { data, error, count } = await supabase
      .from('favorites')
      .select(`
        id,
        created_at,
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
          rating,
          reviews_count,
          stores (
            id,
            name,
            logo_url,
            is_verified
          )
        )
      `, { count: 'exact' })
      .eq('user_id', customerId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      console.error('[getFavorites] Error:', error);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    // Transform data
    const favorites = (data || []).map((item: any) => ({
      id: item.id,
      added_at: item.created_at,
      product: item.products ? {
        id: item.products.id,
        name: item.products.name,
        description: item.products.description,
        price: item.products.price,
        compare_at_price: item.products.compare_at_price,
        stock: item.products.stock,
        image_url: item.products.main_image_url || item.products.image_url,
        status: item.products.status,
        rating: item.products.rating,
        reviews_count: item.products.reviews_count,
        is_in_stock: item.products.stock > 0,
        store: item.products.stores
      } : null
    })).filter((item: any) => item.product !== null);

    return c.json({
      ok: true,
      data: favorites,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit)
      }
    });

  } catch (error: any) {
    console.error('[getFavorites] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * POST /api/customer/favorites
 * Add product to favorites
 */
export async function addToFavorites(c: FavoritesContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const body = await c.req.json();
    const { product_id } = body;

    if (!product_id) {
      return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Product ID is required' }, 400);
    }

    const supabase = getSupabase(c.env);

    // Verify product exists
    const { data: product, error: productError } = await supabase
      .from('products')
      .select('id, name')
      .eq('id', product_id)
      .single();

    if (productError || !product) {
      return c.json({ ok: false, error: 'PRODUCT_NOT_FOUND', message: 'Product not found' }, 404);
    }

    // Check if already in favorites
    const { data: existing } = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', customerId)
      .eq('product_id', product_id)
      .single();

    if (existing) {
      return c.json({ ok: true, message: 'Product already in favorites', data: { id: existing.id } });
    }

    // Add to favorites
    const { data: favorite, error: insertError } = await supabase
      .from('favorites')
      .insert({
        user_id: customerId,
        product_id: product_id
      })
      .select('id')
      .single();

    if (insertError) {
      console.error('[addToFavorites] Error:', insertError);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: insertError.message }, 500);
    }

    return c.json({ 
      ok: true, 
      message: 'Product added to favorites', 
      data: { id: favorite.id } 
    }, 201);

  } catch (error: any) {
    console.error('[addToFavorites] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * DELETE /api/customer/favorites/:productId
 * Remove product from favorites
 */
export async function removeFromFavorites(c: FavoritesContext) {
  const customerId = c.get('userId');
  const productId = c.req.param('productId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!productId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Product ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    // Delete from favorites
    const { error: deleteError } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', customerId)
      .eq('product_id', productId);

    if (deleteError) {
      console.error('[removeFromFavorites] Error:', deleteError);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: deleteError.message }, 500);
    }

    return c.json({ ok: true, message: 'Product removed from favorites' });

  } catch (error: any) {
    console.error('[removeFromFavorites] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/favorites/check/:productId
 * Check if product is in favorites
 */
export async function checkFavorite(c: FavoritesContext) {
  const customerId = c.get('userId');
  const productId = c.req.param('productId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!productId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Product ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    const { data, error } = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', customerId)
      .eq('product_id', productId)
      .single();

    if (error && error.code !== 'PGRST116') {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    return c.json({ 
      ok: true, 
      data: { 
        is_favorite: !!data,
        favorite_id: data?.id || null
      } 
    });

  } catch (error: any) {
    console.error('[checkFavorite] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * POST /api/customer/favorites/toggle/:productId
 * Toggle product in favorites (add if not exists, remove if exists)
 */
export async function toggleFavorite(c: FavoritesContext) {
  const customerId = c.get('userId');
  const productId = c.req.param('productId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  if (!productId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Product ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);

    // Check if exists
    const { data: existing } = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', customerId)
      .eq('product_id', productId)
      .single();

    if (existing) {
      // Remove from favorites
      await supabase
        .from('favorites')
        .delete()
        .eq('id', existing.id);

      return c.json({ 
        ok: true, 
        message: 'Product removed from favorites',
        data: { is_favorite: false }
      });
    } else {
      // Verify product exists
      const { data: product } = await supabase
        .from('products')
        .select('id')
        .eq('id', productId)
        .single();

      if (!product) {
        return c.json({ ok: false, error: 'PRODUCT_NOT_FOUND', message: 'Product not found' }, 404);
      }

      // Add to favorites
      const { data: favorite, error: insertError } = await supabase
        .from('favorites')
        .insert({
          user_id: customerId,
          product_id: productId
        })
        .select('id')
        .single();

      if (insertError) {
        return c.json({ ok: false, error: 'DATABASE_ERROR', message: insertError.message }, 500);
      }

      return c.json({ 
        ok: true, 
        message: 'Product added to favorites',
        data: { is_favorite: true, favorite_id: favorite.id }
      });
    }

  } catch (error: any) {
    console.error('[toggleFavorite] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/customer/favorites/count
 * Get favorites count
 */
export async function getFavoritesCount(c: FavoritesContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);

    const { count, error } = await supabase
      .from('favorites')
      .select('id', { count: 'exact', head: true })
      .eq('user_id', customerId);

    if (error) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    return c.json({ ok: true, data: { count: count || 0 } });

  } catch (error: any) {
    console.error('[getFavoritesCount] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * DELETE /api/customer/favorites
 * Clear all favorites
 */
export async function clearFavorites(c: FavoritesContext) {
  const customerId = c.get('userId');
  
  if (!customerId) {
    return c.json({ ok: false, error: 'UNAUTHORIZED', message: 'Customer authentication required' }, 401);
  }

  try {
    const supabase = getSupabase(c.env);

    const { error } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', customerId);

    if (error) {
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    return c.json({ ok: true, message: 'All favorites cleared' });

  } catch (error: any) {
    console.error('[clearFavorites] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}
