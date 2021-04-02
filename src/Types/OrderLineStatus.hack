namespace Mollie\Api\Types;

enum OrderLineStatus: string {
  /**
   * The order line has just been created.
   */
  STATUS_CREATED = 'created';

  /**
   * The order line has been paid.
   */
  STATUS_PAID = 'paid';

  /**
   * The order line has been authorized.
   */
  STATUS_AUTHORIZED = 'authorized';

  /**
   * The order line has been canceled.
   */
  STATUS_CANCELED = 'canceled';

  /**
   * (Deprecated) The order line has been refunded.
   * @deprecated
   */
  STATUS_REFUNDED = 'refunded';

  /**
   * The order line is shipping.
   */
  STATUS_SHIPPING = 'shipping';

  /**
   * The order line is completed.
   */
  STATUS_COMPLETED = 'completed';
}
