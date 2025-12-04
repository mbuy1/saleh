/**
 * MBUY Edge Function: product_update
 * Update an existing product
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface ProductUpdateRequest {
  user_id: string;
  product_id: string;
  name?: string;
  description?: string;
  price?: number;
  stock_quantity?: number;
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

    const body: ProductUpdateRequest = await req.json();
    const { user_id, product_id, ...updates } = body;

    if (!user_id || !product_id) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing user_id or product_id' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (Object.keys(updates).length === 0) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'No fields to update' }),
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

    // Verify ownership
    const { data: store } = await supabase
      .from('stores')
      .select('id')
      .eq('owner_id', user_id)
      .single();

    if (!store) {
      return new Response(
        JSON.stringify({ error: 'Forbidden', detail: 'User does not own a store' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const { data: product } = await supabase
      .from('products')
      .select('store_id')
      .eq('id', product_id)
      .single();

    if (!product || product.store_id !== store.id) {
      return new Response(
        JSON.stringify({ error: 'Forbidden', detail: 'Product not found or does not belong to user' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Update product
    const { data: updatedProduct, error: updateError } = await supabase
      .from('products')
      .update(updates)
      .eq('id', product_id)
      .select()
      .single();

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        ok: true,
        data: updatedProduct,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in product_update:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: 'Internal server error', detail: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
