namespace Mollie\Api\Types;

enum OrderStatus: string {
  /**
   * The order has just been created.
   */
  STATUS_CREATED = 'created';

  /**
   * The order has been paid.
   */
  STATUS_PAID = 'paid';

  /**
   * The order has been authorized.
   */
  STATUS_AUTHORIZED = 'authorized';

  /**
   * The order has been canceled.
   */
  STATUS_CANCELED = 'canceled';

  /**
   * The order is shipping.
   */
  STATUS_SHIPPING = 'shipping';

  /**
   * The order is completed.
   */
  STATUS_COMPLETED = 'completed';

  /**
   * The order is expired.
   */
  STATUS_EXPIRED = 'expired';

  /**
   * The order is pending.
   */
  STATUS_PENDING = 'pending';

  /**
   * (Deprecated) The order has been refunded.
   * @deprecated 2018-11-27
   */
  STATUS_REFUNDED = 'refunded';
}
