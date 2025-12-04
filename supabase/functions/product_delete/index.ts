/**
 * MBUY Edge Function: product_delete
 * Delete a product from merchant's store
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface ProductDeleteRequest {
  user_id: string;
  product_id: string;
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

    const body: ProductDeleteRequest = await req.json();
    const { user_id, product_id } = body;

    if (!user_id || !product_id) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing user_id or product_id' }),
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

    // Delete product
    const { error: deleteError } = await supabase
      .from('products')
      .delete()
      .eq('id', product_id);

    if (deleteError) throw deleteError;

    return new Response(
      JSON.stringify({
        ok: true,
        message: 'Product deleted successfully',
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in product_delete:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: 'Internal server error', detail: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
