/**
 * Order Processing Workflow
 * Handles the complete order lifecycle
 */
import { WorkflowEntrypoint, WorkflowStep, WorkflowEvent } from 'cloudflare:workers';

type OrderData = {
  orderId: string;
  customerId: string;
  totalAmount: number;
  items: any[];
};

export class OrderWorkflow extends WorkflowEntrypoint<any, OrderData> {
  async run(event: WorkflowEvent<OrderData>, step: WorkflowStep) {
    const order = event.payload;

    // Step 1: Validate order
    await step.do('validate-order', async () => {
      console.log(`Validating order ${order.orderId}`);
      // Add validation logic
      return { valid: true };
    });

    // Step 2: Process payment
    const paymentResult = await step.do('process-payment', async () => {
      console.log(`Processing payment for order ${order.orderId}`);
      // Add payment processing logic
      return { success: true, transactionId: crypto.randomUUID() };
    });

    // Step 3: Update inventory
    await step.do('update-inventory', async () => {
      console.log(`Updating inventory for order ${order.orderId}`);
      // Add inventory update logic
      return { updated: true };
    });

    // Step 4: Send notifications
    await step.do('send-notifications', async () => {
      console.log(`Sending notifications for order ${order.orderId}`);
      // Add notification logic
      return { sent: true };
    });

    // Step 5: Schedule delivery
    await step.sleep('wait-for-processing', '1 minute');

    await step.do('schedule-delivery', async () => {
      console.log(`Scheduling delivery for order ${order.orderId}`);
      return { scheduled: true, estimatedDelivery: Date.now() + 86400000 };
    });

    return {
      orderId: order.orderId,
      status: 'completed',
      paymentTransactionId: paymentResult.transactionId
    };
  }
}
