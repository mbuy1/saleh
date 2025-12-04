/**
 * Shared validation utilities for Edge Functions
 */

// Validate UUID format
export function isValidUUID(uuid: string): boolean {
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  return uuidRegex.test(uuid);
}

// Validate email format
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Validate phone number (Saudi format)
export function isValidPhone(phone: string): boolean {
  const phoneRegex = /^(05|5)[0-9]{8}$/;
  return phoneRegex.test(phone.replace(/[\s-]/g, ''));
}

// Validate amount (positive number)
export function isValidAmount(amount: number): boolean {
  return typeof amount === 'number' && amount > 0 && amount <= 1000000; // Max 1M
}

// Validate quantity (positive integer)
export function isValidQuantity(quantity: number): boolean {
  return Number.isInteger(quantity) && quantity > 0 && quantity <= 1000; // Max 1000
}

// Validate string length
export function isValidStringLength(str: string, min: number, max: number): boolean {
  return typeof str === 'string' && str.length >= min && str.length <= max;
}

// Sanitize string input
export function sanitizeString(input: string): string {
  return input.trim().replace(/[<>]/g, '');
}

// Validate payment method
export function isValidPaymentMethod(method: string): boolean {
  const validMethods = ['cash', 'card', 'wallet', 'tap', 'hyperpay', 'tamara', 'tabby'];
  return validMethods.includes(method.toLowerCase());
}

// Validate order status
export function isValidOrderStatus(status: string): boolean {
  const validStatuses = ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
  return validStatuses.includes(status.toLowerCase());
}

// Validate wallet transaction type
export function isValidWalletTransactionType(type: string): boolean {
  const validTypes = ['deposit', 'withdraw', 'refund', 'bonus', 'penalty'];
  return validTypes.includes(type.toLowerCase());
}

// Validate points transaction type
export function isValidPointsTransactionType(type: string): boolean {
  const validTypes = ['earn', 'spend', 'expire', 'bonus', 'penalty'];
  return validTypes.includes(type.toLowerCase());
}

// Validate coupon code format
export function isValidCouponCode(code: string): boolean {
  return /^[A-Z0-9]{4,20}$/.test(code.toUpperCase());
}

// Validate required fields
export function validateRequiredFields(data: Record<string, any>, fields: string[]): string[] {
  const missing: string[] = [];
  for (const field of fields) {
    if (data[field] === undefined || data[field] === null || data[field] === '') {
      missing.push(field);
    }
  }
  return missing;
}

// Validate request body structure
export function validateRequestBody(body: any, schema: Record<string, (value: any) => boolean>): string[] {
  const errors: string[] = [];
  
  for (const [field, validator] of Object.entries(schema)) {
    if (body[field] === undefined) {
      errors.push(`Missing required field: ${field}`);
    } else if (!validator(body[field])) {
      errors.push(`Invalid value for field: ${field}`);
    }
  }
  
  return errors;
}

