/**
 * Search Endpoints - البحث في المتاجر والمنتجات
 * 
 * Comprehensive search functionality for customers
 * 
 * @module endpoints/search
 */

import { Context } from 'hono';
import { createClient } from '@supabase/supabase-js';
import { Env, AuthContext } from '../types';

type SearchContext = Context<{ Bindings: Env; Variables: AuthContext }>;

/**
 * Helper: Get Supabase client with service_role
 */
function getSupabase(env: Env) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });
}

// =====================================================
// SEARCH OPERATIONS
// =====================================================

/**
 * GET /api/search/products
 * Search products with filters
 */
export async function searchProducts(c: SearchContext) {
  try {
    const supabase = getSupabase(c.env);
    
    // Query parameters
    const query = c.req.query('q') || '';
    const categoryId = c.req.query('category_id');
    const storeId = c.req.query('store_id');
    const minPrice = c.req.query('min_price');
    const maxPrice = c.req.query('max_price');
    const sortBy = c.req.query('sort_by') || 'relevance'; // relevance, price_asc, price_desc, newest, rating
    const inStock = c.req.query('in_stock') === 'true';
    const page = parseInt(c.req.query('page') || '1');
    const limit = parseInt(c.req.query('limit') || '20');
    const offset = (page - 1) * limit;

    // Build query
    let dbQuery = supabase
      .from('products')
      .select(`
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
        sales_count,
        created_at,
        stores!inner (
          id,
          name,
          logo_url,
          is_verified,
          rating
        )
      `, { count: 'exact' })
      .eq('status', 'active');

    // Text search (if query provided)
    if (query) {
      // Use ilike for simple text search (PostgreSQL full-text search would be better)
      dbQuery = dbQuery.or(`name.ilike.%${query}%,description.ilike.%${query}%`);
    }

    // Filter by category
    if (categoryId) {
      // Join with product_categories table
      const { data: productIds } = await supabase
        .from('product_categories')
        .select('product_id')
        .eq('category_id', categoryId);
      
      if (productIds && productIds.length > 0) {
        dbQuery = dbQuery.in('id', productIds.map(p => p.product_id));
      } else {
        // No products in this category
        return c.json({ ok: true, data: [], pagination: { page, limit, total: 0, total_pages: 0 } });
      }
    }

    // Filter by store
    if (storeId) {
      dbQuery = dbQuery.eq('store_id', storeId);
    }

    // Price range
    if (minPrice) {
      dbQuery = dbQuery.gte('price', parseFloat(minPrice));
    }
    if (maxPrice) {
      dbQuery = dbQuery.lte('price', parseFloat(maxPrice));
    }

    // In stock filter
    if (inStock) {
      dbQuery = dbQuery.gt('stock', 0);
    }

    // Sorting
    switch (sortBy) {
      case 'price_asc':
        dbQuery = dbQuery.order('price', { ascending: true });
        break;
      case 'price_desc':
        dbQuery = dbQuery.order('price', { ascending: false });
        break;
      case 'newest':
        dbQuery = dbQuery.order('created_at', { ascending: false });
        break;
      case 'rating':
        dbQuery = dbQuery.order('rating', { ascending: false, nullsFirst: false });
        break;
      case 'popular':
        dbQuery = dbQuery.order('sales_count', { ascending: false, nullsFirst: false });
        break;
      default: // relevance - by name match quality
        dbQuery = dbQuery.order('sales_count', { ascending: false, nullsFirst: false });
    }

    // Pagination
    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;

    if (error) {
      console.error('[searchProducts] Error:', error);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    // Transform results
    const products = (data || []).map((product: any) => ({
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      compare_at_price: product.compare_at_price,
      discount_percent: product.compare_at_price 
        ? Math.round(((product.compare_at_price - product.price) / product.compare_at_price) * 100)
        : null,
      stock: product.stock,
      is_in_stock: product.stock > 0,
      image_url: product.main_image_url || product.image_url,
      rating: product.rating,
      reviews_count: product.reviews_count,
      store: product.stores
    }));

    return c.json({
      ok: true,
      data: products,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit)
      }
    });

  } catch (error: any) {
    console.error('[searchProducts] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/search/stores
 * Search stores
 */
export async function searchStores(c: SearchContext) {
  try {
    const supabase = getSupabase(c.env);
    
    const query = c.req.query('q') || '';
    const categoryId = c.req.query('category_id');
    const city = c.req.query('city');
    const isVerified = c.req.query('verified') === 'true';
    const sortBy = c.req.query('sort_by') || 'relevance'; // relevance, rating, followers, newest
    const page = parseInt(c.req.query('page') || '1');
    const limit = parseInt(c.req.query('limit') || '20');
    const offset = (page - 1) * limit;

    let dbQuery = supabase
      .from('stores')
      .select(`
        id,
        name,
        description,
        slug,
        city,
        logo_url,
        cover_image_url,
        rating,
        followers_count,
        is_verified,
        status,
        created_at
      `, { count: 'exact' })
      .eq('status', 'active')
      .eq('visibility', 'public');

    // Text search
    if (query) {
      dbQuery = dbQuery.or(`name.ilike.%${query}%,description.ilike.%${query}%`);
    }

    // Filter by city
    if (city) {
      dbQuery = dbQuery.eq('city', city);
    }

    // Verified filter
    if (isVerified) {
      dbQuery = dbQuery.eq('is_verified', true);
    }

    // Sorting
    switch (sortBy) {
      case 'rating':
        dbQuery = dbQuery.order('rating', { ascending: false, nullsFirst: false });
        break;
      case 'followers':
        dbQuery = dbQuery.order('followers_count', { ascending: false, nullsFirst: false });
        break;
      case 'newest':
        dbQuery = dbQuery.order('created_at', { ascending: false });
        break;
      default: // relevance
        dbQuery = dbQuery.order('followers_count', { ascending: false, nullsFirst: false });
    }

    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;

    if (error) {
      console.error('[searchStores] Error:', error);
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
    console.error('[searchStores] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/search/suggestions
 * Get search suggestions based on query
 */
export async function getSearchSuggestions(c: SearchContext) {
  try {
    const query = c.req.query('q') || '';
    
    if (query.length < 2) {
      return c.json({ ok: true, data: { products: [], stores: [], categories: [] } });
    }

    const supabase = getSupabase(c.env);

    // Get product suggestions
    const { data: products } = await supabase
      .from('products')
      .select('id, name, main_image_url, image_url, price')
      .eq('status', 'active')
      .ilike('name', `%${query}%`)
      .limit(5);

    // Get store suggestions
    const { data: stores } = await supabase
      .from('stores')
      .select('id, name, logo_url')
      .eq('status', 'active')
      .eq('visibility', 'public')
      .ilike('name', `%${query}%`)
      .limit(3);

    // Get category suggestions
    const { data: categories } = await supabase
      .from('categories')
      .select('id, name, name_ar, icon')
      .eq('is_active', true)
      .or(`name.ilike.%${query}%,name_ar.ilike.%${query}%`)
      .limit(3);

    return c.json({
      ok: true,
      data: {
        products: (products || []).map((p: any) => ({
          id: p.id,
          name: p.name,
          image_url: p.main_image_url || p.image_url,
          price: p.price
        })),
        stores: stores || [],
        categories: categories || []
      }
    });

  } catch (error: any) {
    console.error('[getSearchSuggestions] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/search/trending
 * Get trending searches and products
 */
export async function getTrendingSearches(c: SearchContext) {
  try {
    const supabase = getSupabase(c.env);

    // Get trending products (most sold)
    const { data: trendingProducts } = await supabase
      .from('products')
      .select(`
        id,
        name,
        price,
        main_image_url,
        image_url,
        rating,
        sales_count,
        stores (id, name, logo_url)
      `)
      .eq('status', 'active')
      .order('sales_count', { ascending: false, nullsFirst: false })
      .limit(10);

    // Get popular categories
    const { data: categories } = await supabase
      .from('categories')
      .select('id, name, name_ar, icon')
      .eq('is_active', true)
      .is('parent_id', null) // Top-level categories only
      .limit(8);

    // Static trending keywords (could be from analytics)
    const trendingKeywords = [
      'أحذية',
      'إلكترونيات',
      'ساعات',
      'عطور',
      'ملابس',
      'مكياج'
    ];

    return c.json({
      ok: true,
      data: {
        trending_products: (trendingProducts || []).map((p: any) => ({
          id: p.id,
          name: p.name,
          price: p.price,
          image_url: p.main_image_url || p.image_url,
          rating: p.rating,
          store: p.stores
        })),
        categories: categories || [],
        trending_keywords: trendingKeywords
      }
    });

  } catch (error: any) {
    console.error('[getTrendingSearches] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/categories
 * Get all categories with hierarchy
 */
export async function getCategories(c: SearchContext) {
  try {
    const supabase = getSupabase(c.env);
    
    const parentOnly = c.req.query('parent_only') === 'true';

    let query = supabase
      .from('categories')
      .select('id, name, name_ar, description, parent_id, icon, slug, display_order')
      .eq('is_active', true)
      .order('display_order', { ascending: true });

    if (parentOnly) {
      query = query.is('parent_id', null);
    }

    const { data, error } = await query;

    if (error) {
      console.error('[getCategories] Error:', error);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    // Build tree structure if not parent_only
    if (!parentOnly) {
      const categoryMap = new Map();
      const rootCategories: any[] = [];

      (data || []).forEach((cat: any) => {
        categoryMap.set(cat.id, { ...cat, subcategories: [] });
      });

      (data || []).forEach((cat: any) => {
        if (cat.parent_id) {
          const parent = categoryMap.get(cat.parent_id);
          if (parent) {
            parent.subcategories.push(categoryMap.get(cat.id));
          }
        } else {
          rootCategories.push(categoryMap.get(cat.id));
        }
      });

      return c.json({ ok: true, data: rootCategories });
    }

    return c.json({ ok: true, data: data || [] });

  } catch (error: any) {
    console.error('[getCategories] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}

/**
 * GET /api/categories/:id/products
 * Get products by category
 */
export async function getProductsByCategory(c: SearchContext) {
  const categoryId = c.req.param('id');
  
  if (!categoryId) {
    return c.json({ ok: false, error: 'MISSING_PARAMS', message: 'Category ID is required' }, 400);
  }

  try {
    const supabase = getSupabase(c.env);
    
    const page = parseInt(c.req.query('page') || '1');
    const limit = parseInt(c.req.query('limit') || '20');
    const sortBy = c.req.query('sort_by') || 'popular';
    const offset = (page - 1) * limit;

    // Get product IDs in this category (including subcategories)
    // First get all subcategory IDs
    const { data: subcategories } = await supabase
      .from('categories')
      .select('id')
      .eq('parent_id', categoryId);

    const categoryIds = [categoryId, ...(subcategories || []).map(s => s.id)];

    // Get products in these categories
    const { data: productCategories } = await supabase
      .from('product_categories')
      .select('product_id')
      .in('category_id', categoryIds);

    if (!productCategories || productCategories.length === 0) {
      return c.json({
        ok: true,
        data: [],
        pagination: { page, limit, total: 0, total_pages: 0 }
      });
    }

    const productIds = [...new Set(productCategories.map(pc => pc.product_id))];

    // Build product query
    let query = supabase
      .from('products')
      .select(`
        id,
        name,
        description,
        price,
        compare_at_price,
        stock,
        main_image_url,
        image_url,
        rating,
        reviews_count,
        sales_count,
        stores (id, name, logo_url, is_verified)
      `, { count: 'exact' })
      .eq('status', 'active')
      .in('id', productIds);

    // Sorting
    switch (sortBy) {
      case 'price_asc':
        query = query.order('price', { ascending: true });
        break;
      case 'price_desc':
        query = query.order('price', { ascending: false });
        break;
      case 'newest':
        query = query.order('created_at', { ascending: false });
        break;
      case 'rating':
        query = query.order('rating', { ascending: false, nullsFirst: false });
        break;
      default: // popular
        query = query.order('sales_count', { ascending: false, nullsFirst: false });
    }

    query = query.range(offset, offset + limit - 1);

    const { data, error, count } = await query;

    if (error) {
      console.error('[getProductsByCategory] Error:', error);
      return c.json({ ok: false, error: 'DATABASE_ERROR', message: error.message }, 500);
    }

    const products = (data || []).map((p: any) => ({
      ...p,
      image_url: p.main_image_url || p.image_url,
      is_in_stock: p.stock > 0,
      discount_percent: p.compare_at_price 
        ? Math.round(((p.compare_at_price - p.price) / p.compare_at_price) * 100)
        : null
    }));

    return c.json({
      ok: true,
      data: products,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit)
      }
    });

  } catch (error: any) {
    console.error('[getProductsByCategory] Exception:', error);
    return c.json({ ok: false, error: 'INTERNAL_ERROR', message: error.message }, 500);
  }
}
