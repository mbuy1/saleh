/**
 * Type definitions for MBUY Worker
 */

export interface Env {
  // Cloudflare Account
  CF_ACCOUNT_ID: string;

  // Cloudflare Images
  CF_IMAGES_ACCOUNT_ID: string;
  CF_IMAGES_API_TOKEN: string;

  // Cloudflare Stream
  CF_STREAM_ACCOUNT_ID: string;
  CF_STREAM_API_TOKEN: string;

  // Cloudflare R2
  R2_ACCESS_KEY_ID: string;
  R2_SECRET_ACCESS_KEY: string;
  R2_BUCKET_NAME: string;
  R2_S3_ENDPOINT: string;
  R2_PUBLIC_URL: string;

  // Supabase
  SUPABASE_URL: string;
  SUPABASE_JWKS_URL: string;
  SUPABASE_ANON_KEY: string;

  // Internal security
  EDGE_INTERNAL_KEY: string;

  // AI & Advanced Features
  AI: any; // Workers AI binding
  BROWSER: any; // Browser Rendering binding
  AI_GATEWAY_ID: string;
  AI_GATEWAY_TOKEN?: string;
  GEMINI_API_KEY: string; // Gemini AI API key (secure in Worker)
  
  // Durable Objects
  SESSION_STORE: DurableObjectNamespace;
  CHAT_ROOM: DurableObjectNamespace;
  
  // Queues
  ORDER_QUEUE: Queue;
  NOTIFICATION_QUEUE: Queue;
  
  // Workflows
  ORDER_WORKFLOW: Workflow;
  
  // Pages
  PAGES_PROJECT_NAME: string;
  PAGES_API_TOKEN?: string;
}
