/**
 * Order Queue Consumer
 * Processes orders from the queue
 */
export async function handleOrderQueue(batch: MessageBatch<any>, env: any): Promise<void> {
  for (const message of batch.messages) {
    try {
      const order = message.body;
      
      console.log(`Processing order from queue: ${order.orderId}`);
      
      // Process the order
      // You can call Edge Functions, update database, etc.
      
      // Example: Call create_order Edge Function
      const response = await fetch(`${env.SUPABASE_URL}/functions/v1/create_order`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-internal-key': env.EDGE_INTERNAL_KEY,
        },
        body: JSON.stringify(order),
      });

      if (response.ok) {
        console.log(`Order ${order.orderId} processed successfully`);
        message.ack();
      } else {
        console.error(`Failed to process order ${order.orderId}`);
        message.retry();
      }
    } catch (error) {
      console.error('Error processing order:', error);
      message.retry();
    }
  }
}
