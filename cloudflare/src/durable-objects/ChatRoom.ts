/**
 * ChatRoom Durable Object
 * Manages real-time chat rooms with WebSocket support
 */
export class ChatRoom {
  private state: DurableObjectState;
  private sessions: Set<WebSocket>;
  private messages: any[];

  constructor(state: DurableObjectState) {
    this.state = state;
    this.sessions = new Set();
    this.messages = [];
    
    // Load messages from storage
    this.state.blockConcurrencyWhile(async () => {
      const stored = await this.state.storage.get<any[]>('messages');
      if (stored) this.messages = stored;
    });
  }

  async fetch(request: Request): Promise<Response> {
    // Handle WebSocket upgrade
    if (request.headers.get('Upgrade') === 'websocket') {
      const pair = new WebSocketPair();
      const [client, server] = Object.values(pair);

      await this.handleSession(server);

      return new Response(null, {
        status: 101,
        webSocket: client,
      });
    }

    // HTTP endpoints
    const url = new URL(request.url);
    if (url.pathname === '/messages' && request.method === 'GET') {
      return new Response(JSON.stringify({ ok: true, messages: this.messages }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }

    return new Response('Expected WebSocket', { status: 426 });
  }

  async handleSession(webSocket: WebSocket) {
    webSocket.accept();
    this.sessions.add(webSocket);

    // Send history
    webSocket.send(JSON.stringify({
      type: 'history',
      messages: this.messages
    }));

    webSocket.addEventListener('message', async (event) => {
      try {
        const data = JSON.parse(event.data as string);
        
        const message = {
          id: crypto.randomUUID(),
          userId: data.userId,
          text: data.text,
          timestamp: Date.now()
        };

        this.messages.push(message);
        
        // Save to storage
        await this.state.storage.put('messages', this.messages);

        // Broadcast to all connected clients
        const broadcast = JSON.stringify({
          type: 'message',
          message
        });

        this.sessions.forEach(session => {
          try {
            session.send(broadcast);
          } catch (err) {
            // Client disconnected
          }
        });
      } catch (err) {
        webSocket.send(JSON.stringify({ error: 'Invalid message format' }));
      }
    });

    webSocket.addEventListener('close', () => {
      this.sessions.delete(webSocket);
    });
  }
}
