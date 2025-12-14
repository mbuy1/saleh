# NanoBanana AI Integration

This document describes the integration of NanoBanana AI into the MBUY platform via the Cloudflare Worker.

## Overview

The integration allows MBUY users to generate AI content (images, videos, etc.) using NanoBanana's API. All requests are proxied through the MBUY Cloudflare Worker to ensure security and hide the API key.

## Endpoints

### 1. Generate Content

**Endpoint:** `POST /secure/ai/nano-banana/generate`

**Headers:**
- `Authorization`: `Bearer <USER_JWT>` (Supabase JWT)
- `Content-Type`: `application/json`

**Body:**
```json
{
  "prompt": "A futuristic city with flying cars, cyberpunk style"
}
```

**Response:**
```json
{
  "taskId": "task_1234567890"
}
```

### 2. Get Task Status/Result

**Endpoint:** `GET /secure/ai/nano-banana/task?taskId=<TASK_ID>`

**Headers:**
- `Authorization`: `Bearer <USER_JWT>` (Supabase JWT)

**Response (Pending):**
```json
{
  "status": "processing",
  "progress": 0.5
}
```

**Response (Completed):**
```json
{
  "status": "completed",
  "result": [
    "https://nanobanana.com/result/image1.png",
    "https://nanobanana.com/result/image2.png"
  ]
}
```

## Security

- The `NANO_BANANA_API_KEY` is stored as a secret in the Cloudflare Worker environment.
- Users must be authenticated via Supabase JWT to access these endpoints.
- The worker validates the JWT before forwarding the request.

## Implementation Details

- **Worker File:** `src/endpoints/ai.ts`
- **Routes:** Defined in `src/index.ts`
- **Environment Variable:** `NANO_BANANA_API_KEY` must be set in Cloudflare Dashboard or `.dev.vars`.
