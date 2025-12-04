/**
 * MBUY Edge Function: products_list
 * Get products for merchant's store
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface ProductsListRequest {
  user_id: string;
  store_id?: string;
  limit?: number;
  offset?: number;
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

    const body: ProductsListRequest = await req.json();
    const { user_id, store_id, limit = 50, offset = 0 } = body;

    if (!user_id) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing user_id' }),
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
    let targetStoreId = store_id;
    if (!targetStoreId) {
      const { data: store } = await supabase
        .from('stores')
        .select('id')
        .eq('owner_id', user_id)
        .single();
      
      if (!store) {
        return new Response(
          JSON.stringify({ error: 'Store not found', detail: 'User does not have a store' }),
          { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
      targetStoreId = store.id;
    }

    // Get products
    const { data: products, error, count } = await supabase
      .from('products')
      .select('*', { count: 'exact' })
      .eq('store_id', targetStoreId)
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    if (error) throw error;

    return new Response(
      JSON.stringify({
        ok: true,
        data: products || [],
        total: count || 0,
        limit,
        offset,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in products_list:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: 'Internal server error', detail: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
