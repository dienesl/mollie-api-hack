namespace Mollie\Api\Types;

enum SubscriptionStatus: string {
  STATUS_ACTIVE = 'active';
  STATUS_PENDING = 'pending';   // Waiting for a valid mandate.
  STATUS_CANCELED = 'canceled';
  STATUS_SUSPENDED = 'suspended'; // Active, but mandate became invalid.
  STATUS_COMPLETED = 'completed';
}
