namespace Mollie\Api\Resources;

/**
 * @method Refund[]|RefundCollection all($from = null, $limit = 50, array $filters = [])
 * @method Refund get($refundId, array $filters = [])
 * @method Refund create(array $data = [], array $filters = [])
 * @method Refund delete($refundId)
 */
class Chargeback extends BaseResource {
  /**
   * Id of the payment method.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The $amount that was refunded.
   */
  <<__LateInit>>
  public dict<arraykey, mixed> $amount;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   */
  <<__LateInit>>
  public ?string $createdAt;

  /**
   * The payment id that was refunded.
   */
  <<__LateInit>>
  public string $paymentId;

  /**
   * The settlement amount
   */
  <<__LateInit>>
  public dict<arraykey, mixed> $settlementAmount;

  <<__LateInit>>
  public Links $links;
}
