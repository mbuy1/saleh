/**
 * MBUY Edge Function: product_create
 * Create a new product in merchant's store
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface ProductCreateRequest {
  user_id: string;
  name: string;
  description?: string;
  price: number;
  stock_quantity: number;
  category?: string;
  main_image_url?: string;
  images?: string[];
  meta?: Record<string, any>;
}

Deno.serve(async (req) => {
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

    const body: ProductCreateRequest = await req.json();
    const { user_id, name, description, price, stock_quantity, category, main_image_url, images, meta } = body;

    // Validation
    const missingFields = [];
    if (!user_id) missingFields.push('user_id');
    if (!name) missingFields.push('name');
    if (price === undefined || price === null) missingFields.push('price');
    if (stock_quantity === undefined || stock_quantity === null) missingFields.push('stock_quantity');

    if (missingFields.length > 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: `Missing required fields: ${missingFields.join(', ')}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (price < 0 || stock_quantity < 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Price and stock quantity must be non-negative' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL') || Deno.env.get('SB_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SB_SERVICE_ROLE_KEY');
    
    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Missing Supabase environment variables');
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    // Get user's store
    const { data: store, error: storeError } = await supabase
      .from('stores')
      .select('id')
      .eq('owner_id', user_id)
      .single();

    if (storeError || !store) {
      return new Response(
        JSON.stringify({ error: 'Store not found', detail: 'User does not have a store' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Create product
    const { data: product, error: createError } = await supabase
      .from('products')
      .insert({
        store_id: store.id,
        name,
        description: description || '',
        price,
        stock_quantity,
        category,
        main_image_url,
        images: images || [],
        meta: meta || {},
      })
      .select()
      .single();

    if (createError) throw createError;

    return new Response(
      JSON.stringify({
        ok: true,
        data: product,
      }),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in product_create:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: 'Internal server error', detail: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
