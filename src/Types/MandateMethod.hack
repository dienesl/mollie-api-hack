namespace Mollie\Api\Types;

enum MandateMethod: string {
  DIRECTDEBIT = 'directdebit';
  CREDITCARD = 'creditcard';
  PAYPAL = 'paypal';
}
