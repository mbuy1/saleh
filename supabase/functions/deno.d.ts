/**
 * Deno Global Types for Supabase Edge Functions
 * This file provides type definitions without requiring Deno extension
 */

declare namespace Deno {
  export namespace env {
    export function get(key: string): string | undefined;
  }

  export function serve(
    handler: (request: Request) => Response | Promise<Response>
  ): void;
}

// Extend global Request type
interface Request extends Body {
  readonly method: string;
  readonly url: string;
  readonly headers: Headers;
  json(): Promise<any>;
  text(): Promise<string>;
  formData(): Promise<FormData>;
}

// Extend global Response type  
interface ResponseInit {
  status?: number;
  statusText?: string;
  headers?: HeadersInit;
}

declare var Response: {
  new(body?: BodyInit | null, init?: ResponseInit): Response;
};

interface Response extends Body {
  readonly status: number;
  readonly statusText: string;
  readonly headers: Headers;
  readonly ok: boolean;
}
