/**
 * MBUY API Gateway - Cloudflare Worker
 * Handles routing, JWT verification, and media uploads
 */

import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { Env } from './types';

const app = new Hono<{ Bindings: Env }>();

// Export Durable Objects
export { SessionStore } from './durable-objects/SessionStore';
export { ChatRoom } from './durable-objects/ChatRoom';

// CORS middleware
app.use('*', cors({
  origin: '*',
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization'],
}));

// Health check
app.get('/', (c) => {
  return c.json({ ok: true, message: 'MBUY API Gateway', version: '1.0.0' });
});

// ============================================================================
// PUBLIC ROUTES - No JWT required
// ============================================================================

app.post('/public/register', async (c) => {
  try {
    const body = await c.req.json();
    
    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/merchant_register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify(body),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Internal server error', detail: error.message }, 500);
  }
});

// ============================================================================
// JWT VERIFICATION MIDDLEWARE
// ============================================================================

// Verify JWT for secure routes
app.use('/secure/*', async (c, next) => {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'Unauthorized', detail: 'Missing or invalid token' }, 401);
  }

  const token = authHeader.substring(7);

  try {
    // Verify JWT using Supabase JWKS
    const jwksUrl = c.env.SUPABASE_JWKS_URL;
    const jwksResponse = await fetch(jwksUrl);
    const jwks = await jwksResponse.json();

    // Simple JWT verification (in production, use a proper library)
    // For now, we'll decode and check basic structure
    const parts = token.split('.');
    if (parts.length !== 3) {
      return c.json({ error: 'Invalid token format' }, 401);
    }

    const payload = JSON.parse(atob(parts[1]));
    
    // Check expiration
    if (payload.exp && payload.exp < Date.now() / 1000) {
      return c.json({ error: 'Token expired' }, 401);
    }

    // Store user info in context
    c.set('userId', payload.sub);
    c.set('userEmail', payload.email);
    
    await next();
  } catch (error: any) {
    return c.json({ error: 'Invalid token', detail: error.message }, 401);
  }
});

// ============================================================================
// MEDIA ROUTES
// ============================================================================

// Upload image to Cloudflare Images
app.post('/media/image', async (c) => {
  try {
    const body = await c.req.json();
    const { filename } = body;

    // Generate unique ID
    const imageId = crypto.randomUUID();
    
    // Create direct upload URL for Cloudflare Images
    const uploadResponse = await fetch(
      `https://api.cloudflare.com/client/v4/accounts/${c.env.CF_IMAGES_ACCOUNT_ID}/images/v2/direct_upload`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${c.env.CF_IMAGES_API_TOKEN}`,
        },
      }
    );

    if (!uploadResponse.ok) {
      const error = await uploadResponse.text();
      return c.json({ error: 'Failed to create upload URL', detail: error }, 500);
    }

    const uploadData: any = await uploadResponse.json();

    return c.json({
      ok: true,
      uploadURL: uploadData.result.uploadURL,
      id: uploadData.result.id,
      viewURL: `https://imagedelivery.net/${c.env.CF_IMAGES_ACCOUNT_ID}/${uploadData.result.id}/public`,
    });
  } catch (error: any) {
    return c.json({ error: 'Failed to process image upload', detail: error.message }, 500);
  }
});

// Upload video to Cloudflare Stream
app.post('/media/video', async (c) => {
  try {
    const body = await c.req.json();
    const { filename } = body;

    // Create direct upload URL for Stream
    const uploadResponse = await fetch(
      `https://api.cloudflare.com/client/v4/accounts/${c.env.CF_STREAM_ACCOUNT_ID}/stream/direct_upload`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${c.env.CF_STREAM_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          maxDurationSeconds: 3600, // 1 hour max
          requireSignedURLs: false,
        }),
      }
    );

    if (!uploadResponse.ok) {
      const error = await uploadResponse.text();
      return c.json({ error: 'Failed to create video upload URL', detail: error }, 500);
    }

    const uploadData: any = await uploadResponse.json();

    return c.json({
      ok: true,
      uploadURL: uploadData.result.uploadURL,
      playbackId: uploadData.result.uid,
      viewURL: `https://customer-${c.env.CF_STREAM_ACCOUNT_ID}.cloudflarestream.com/${uploadData.result.uid}/manifest/video.m3u8`,
    });
  } catch (error: any) {
    return c.json({ error: 'Failed to process video upload', detail: error.message }, 500);
  }
});

// ============================================================================
// SECURE ROUTES - JWT required
// ============================================================================

// Wallet operations
app.post('/secure/wallet/add', async (c) => {
  try {
    const userId = c.get('userId');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/wallet_add`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to add wallet funds', detail: error.message }, 500);
  }
});

// Points operations
app.post('/secure/points/add', async (c) => {
  try {
    const userId = c.get('userId');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/points_add`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to add points', detail: error.message }, 500);
  }
});

// Create order
app.post('/secure/orders/create', async (c) => {
  try {
    const userId = c.get('userId');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/create_order`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to create order', detail: error.message }, 500);
  }
});

// Get user wallet
app.get('/secure/wallet', async (c) => {
  try {
    const userId = c.get('userId');

    // Query Supabase directly with anon key (read only)
    const response = await fetch(
      `${c.env.SUPABASE_URL}/rest/v1/wallets?owner_id=eq.${userId}&type=eq.customer&select=*`,
      {
        headers: {
          'apikey': c.env.SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${c.env.SUPABASE_ANON_KEY}`,
        },
      }
    );

    const data = await response.json();
    return c.json({ ok: true, data: data[0] || null });
  } catch (error: any) {
    return c.json({ error: 'Failed to get wallet', detail: error.message }, 500);
  }
});

// Get user points
app.get('/secure/points', async (c) => {
  try {
    const userId = c.get('userId');

    // Query Supabase directly with anon key (read only)
    const response = await fetch(
      `${c.env.SUPABASE_URL}/rest/v1/points_accounts?user_id=eq.${userId}&select=*`,
      {
        headers: {
          'apikey': c.env.SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${c.env.SUPABASE_ANON_KEY}`,
        },
      }
    );

    const data = await response.json();
    return c.json({ ok: true, data: data[0] || null });
  } catch (error: any) {
    return c.json({ error: 'Failed to get points', detail: error.message }, 500);
  }
});

// ============================================================================
// PRODUCTS & STORES ROUTES
// ============================================================================

// Get products list
app.get('/secure/products', async (c) => {
  try {
    const userId = c.get('userId');
    
    // Query products via Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/products_list`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ user_id: userId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to get products', detail: error.message }, 500);
  }
});

// Create product
app.post('/secure/products', async (c) => {
  try {
    const userId = c.get('userId');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/product_create`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to create product', detail: error.message }, 500);
  }
});

// Update product
app.put('/secure/products/:id', async (c) => {
  try {
    const userId = c.get('userId');
    const productId = c.req.param('id');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/product_update`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId, product_id: productId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to update product', detail: error.message }, 500);
  }
});

// Delete product
app.delete('/secure/products/:id', async (c) => {
  try {
    const userId = c.get('userId');
    const productId = c.req.param('id');

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/product_delete`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ user_id: userId, product_id: productId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to delete product', detail: error.message }, 500);
  }
});

// Get store info
app.get('/secure/stores/:id', async (c) => {
  try {
    const storeId = c.req.param('id');
    
    // Query Supabase directly with anon key (read only - public data)
    const response = await fetch(
      `${c.env.SUPABASE_URL}/rest/v1/stores?id=eq.${storeId}&select=*`,
      {
        headers: {
          'apikey': c.env.SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${c.env.SUPABASE_ANON_KEY}`,
        },
      }
    );

    const data = await response.json();
    return c.json({ ok: true, data: data[0] || null });
  } catch (error: any) {
    return c.json({ error: 'Failed to get store', detail: error.message }, 500);
  }
});

// Update store
app.put('/secure/stores/:id', async (c) => {
  try {
    const userId = c.get('userId');
    const storeId = c.req.param('id');
    const body = await c.req.json();

    // Call Edge Function
    const response = await fetch(`${c.env.SUPABASE_URL}/functions/v1/store_update`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-internal-key': c.env.EDGE_INTERNAL_KEY,
      },
      body: JSON.stringify({ ...body, user_id: userId, store_id: storeId }),
    });

    const data = await response.json();
    return c.json(data, response.status);
  } catch (error: any) {
    return c.json({ error: 'Failed to update store', detail: error.message }, 500);
  }
});

// ============================================================================
// AI & ADVANCED FEATURES ROUTES
// ============================================================================

// AI Text Generation
app.post('/ai/generate', async (c) => {
  try {
    const { prompt, model } = await c.req.json();
    
    const response = await c.env.AI.run(model || '@cf/meta/llama-3.1-8b-instruct', {
      prompt: prompt,
    });

    return c.json({ ok: true, data: response });
  } catch (error: any) {
    return c.json({ error: 'AI generation failed', detail: error.message }, 500);
  }
});

// AI Image Generation
app.post('/ai/image', async (c) => {
  try {
    const { prompt } = await c.req.json();
    
    const response = await c.env.AI.run('@cf/stabilityai/stable-diffusion-xl-base-1.0', {
      prompt: prompt,
    });

    return c.json({ ok: true, data: response });
  } catch (error: any) {
    return c.json({ error: 'Image generation failed', detail: error.message }, 500);
  }
});

// Browser Rendering
app.post('/render', async (c) => {
  try {
    const { url } = await c.req.json();
    
    const browser = await c.env.BROWSER.launch();
    const page = await browser.newPage();
    await page.goto(url);
    const screenshot = await page.screenshot();
    await browser.close();

    return new Response(screenshot, {
      headers: { 'Content-Type': 'image/png' }
    });
  } catch (error: any) {
    return c.json({ error: 'Rendering failed', detail: error.message }, 500);
  }
});

// Durable Objects - Session Store
app.post('/session/:action', async (c) => {
  try {
    const action = c.req.param('action');
    const id = c.env.SESSION_STORE.idFromName('global');
    const stub = c.env.SESSION_STORE.get(id);
    
    const response = await stub.fetch(`https://fake-host/${action}`, {
      method: 'POST',
      body: await c.req.text(),
      headers: { 'Content-Type': 'application/json' }
    });

    return new Response(response.body, {
      status: response.status,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error: any) {
    return c.json({ error: 'Session operation failed', detail: error.message }, 500);
  }
});

// Queue - Add order to queue
app.post('/queue/order', async (c) => {
  try {
    const userId = c.get('userId');
    const order = await c.req.json();
    
    await c.env.ORDER_QUEUE.send({
      ...order,
      userId,
      queuedAt: Date.now()
    });

    return c.json({ ok: true, message: 'Order queued successfully' });
  } catch (error: any) {
    return c.json({ error: 'Queue operation failed', detail: error.message }, 500);
  }
});

// Workflow - Start order workflow
app.post('/workflow/order', async (c) => {
  try {
    const userId = c.get('userId');
    const order = await c.req.json();
    
    const instance = await c.env.ORDER_WORKFLOW.create({
      params: {
        orderId: order.orderId || crypto.randomUUID(),
        customerId: userId,
        totalAmount: order.totalAmount,
        items: order.items
      }
    });

    return c.json({ 
      ok: true, 
      workflowId: instance.id,
      message: 'Workflow started' 
    });
  } catch (error: any) {
    return c.json({ error: 'Workflow start failed', detail: error.message }, 500);
  }
});

// ============================================================================
// GEMINI AI ROUTES (Secure - Replaces direct Flutter calls)
// ============================================================================

// Gemini Chat - Replace gemini_service.dart chat functionality
app.post('/secure/ai/gemini/chat', async (c) => {
  try {
    const { messages, model } = await c.req.json();
    const geminiModel = model || 'gemini-1.5-flash';
    const userId = c.get('userId');

    // Call Gemini API (key stored securely in Worker)
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${geminiModel}:generateContent?key=${c.env.GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: messages.map((msg: any) => ({
            role: msg.role === 'user' ? 'user' : 'model',
            parts: [{ text: msg.content }]
          }))
        })
      }
    );

    const data = await response.json();
    
    if (!response.ok) {
      return c.json({ error: 'Gemini API error', detail: data }, response.status);
    }

    return c.json({ 
      ok: true, 
      response: data.candidates[0].content.parts[0].text,
      model: geminiModel,
      userId 
    });
  } catch (error: any) {
    return c.json({ error: 'Gemini chat failed', detail: error.message }, 500);
  }
});

// Gemini Generate - For product descriptions, sales ideas, etc.
app.post('/secure/ai/gemini/generate', async (c) => {
  try {
    const { prompt, model } = await c.req.json();
    const geminiModel = model || 'gemini-1.5-flash';
    const userId = c.get('userId');

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${geminiModel}:generateContent?key=${c.env.GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }]
        })
      }
    );

    const data = await response.json();
    
    if (!response.ok) {
      return c.json({ error: 'Gemini API error', detail: data }, response.status);
    }

    return c.json({ 
      ok: true, 
      text: data.candidates[0].content.parts[0].text,
      model: geminiModel,
      userId 
    });
  } catch (error: any) {
    return c.json({ error: 'Gemini generation failed', detail: error.message }, 500);
  }
});

// Gemini Vision - Image analysis
app.post('/secure/ai/gemini/vision', async (c) => {
  try {
    const { imageBase64, prompt, model } = await c.req.json();
    const geminiModel = model || 'gemini-1.5-flash';
    const userId = c.get('userId');

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${geminiModel}:generateContent?key=${c.env.GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{
            parts: [
              { text: prompt || 'Describe this image in detail' },
              { 
                inline_data: {
                  mime_type: 'image/jpeg',
                  data: imageBase64
                }
              }
            ]
          }]
        })
      }
    );

    const data = await response.json();
    
    if (!response.ok) {
      return c.json({ error: 'Gemini Vision error', detail: data }, response.status);
    }

    return c.json({ 
      ok: true, 
      analysis: data.candidates[0].content.parts[0].text,
      model: geminiModel,
      userId 
    });
  } catch (error: any) {
    return c.json({ error: 'Gemini vision analysis failed', detail: error.message }, 500);
  }
});

// 404 handler
app.notFound((c) => {
  return c.json({ error: 'Not found', detail: 'Endpoint does not exist' }, 404);
});

// Error handler
app.onError((err, c) => {
  console.error('Worker error:', err);
  return c.json({ error: 'Internal server error', detail: err.message }, 500);
});

// Queue consumer export
export async function queue(batch: MessageBatch<any>, env: any): Promise<void> {
  await handleOrderQueue(batch, env);
}

export default app;
