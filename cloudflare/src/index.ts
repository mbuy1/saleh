/**
 * MBUY API Gateway - Cloudflare Worker
 * Handles routing, JWT verification, and media uploads
 */

import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { Env } from './types';

const app = new Hono<{ Bindings: Env }>();

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

// 404 handler
app.notFound((c) => {
  return c.json({ error: 'Not found', detail: 'Endpoint does not exist' }, 404);
});

// Error handler
app.onError((err, c) => {
  console.error('Worker error:', err);
  return c.json({ error: 'Internal server error', detail: err.message }, 500);
});

export default app;
