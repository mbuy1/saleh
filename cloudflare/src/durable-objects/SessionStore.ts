/**
 * SessionStore Durable Object
 * Manages user sessions with persistence
 */
export class SessionStore {
  private state: DurableObjectState;
  private sessions: Map<string, any>;

  constructor(state: DurableObjectState) {
    this.state = state;
    this.sessions = new Map();
  }

  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    try {
      if (path === '/set' && request.method === 'POST') {
        const { sessionId, data } = await request.json();
        await this.state.storage.put(sessionId, data);
        this.sessions.set(sessionId, data);
        return new Response(JSON.stringify({ ok: true, sessionId }), {
          headers: { 'Content-Type': 'application/json' }
        });
      }

      if (path === '/get' && request.method === 'POST') {
        const { sessionId } = await request.json();
        let data = this.sessions.get(sessionId);
        if (!data) {
          data = await this.state.storage.get(sessionId);
          if (data) this.sessions.set(sessionId, data);
        }
        return new Response(JSON.stringify({ ok: true, data }), {
          headers: { 'Content-Type': 'application/json' }
        });
      }

      if (path === '/delete' && request.method === 'POST') {
        const { sessionId } = await request.json();
        await this.state.storage.delete(sessionId);
        this.sessions.delete(sessionId);
        return new Response(JSON.stringify({ ok: true }), {
          headers: { 'Content-Type': 'application/json' }
        });
      }

      return new Response('Not found', { status: 404 });
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      });
    }
  }
}
