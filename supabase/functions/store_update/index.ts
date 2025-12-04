/**
 * MBUY Edge Function: store_update
 * Update merchant store information
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-internal-key',
};

interface StoreUpdateRequest {
  user_id: string;
  store_id: string;
  name?: string;
  description?: string;
  logo_url?: string;
  banner_url?: string;
  city?: string;
  district?: string;
  address?: string;
  phone?: string;
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

    const body: StoreUpdateRequest = await req.json();
    const { user_id, store_id, ...updates } = body;

    if (!user_id || !store_id) {
      return new Response(
        JSON.stringify({ error: 'Bad request', detail: 'Missing user_id or store_id' }),
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
      .select('owner_id')
      .eq('id', store_id)
      .single();

    if (!store || store.owner_id !== user_id) {
      return new Response(
        JSON.stringify({ error: 'Forbidden', detail: 'Store not found or does not belong to user' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Update store
    const { data: updatedStore, error: updateError } = await supabase
      .from('stores')
      .update(updates)
      .eq('id', store_id)
      .select()
      .single();

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        ok: true,
        data: updatedStore,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in store_update:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: 'Internal server error', detail: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
