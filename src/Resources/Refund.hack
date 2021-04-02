namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\RefundStatus;

class Refund extends BaseResource {
  /**
   * @var string
   */
  public string $resource;

  /**
   * Id of the payment method.
   *
   * @var string
   */
  public string $id;

  /**
   * The $amount that was refunded.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $amount;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public string $createdAt;

  /**
   * The refund's description, if available.
   */
  public ?string $description;

  /**
   * The payment id that was refunded.
   */
  public string $paymentId;

  /**
   * The order id that was refunded.
   */
  public ?string $orderId;

  /**
   * The order lines contain the actual things the customer ordered.
   * The lines will show the quantity, discountAmount, vatAmount and totalAmount
   * refunded.
   *
   * @var array|object[]|null
   * TODO
   */
  public dict<arraykey, mixed> $lines;

  /**
   * The settlement amount
   *
   * @var \stdClass
   * TODO
   */
  public mixed $settlementAmount;

  /**
   * The refund status
   *
   * @var string
   */
  public string $status;

  public Links $links;

  /**
   * Is this refund queued?
   */
  public function isQueued(): bool {
    return $this->status === RefundStatus::STATUS_QUEUED;
  }

  /**
   * Is this refund pending?
   */
  public function isPending(): bool {
    return $this->status === RefundStatus::STATUS_PENDING;
  }

  /**
   * Is this refund processing?
   */
  public function isProcessing(): bool {
    return $this->status === RefundStatus::STATUS_PROCESSING;
  }

  /**
   * Is this refund transferred to consumer?
   */
  public function isTransferred(): bool {
    return $this->status === RefundStatus::STATUS_REFUNDED;
  }

  /**
   * Is this refund failed?
   */
  public function isFailed(): bool {
    return $this->status === RefundStatus::STATUS_FAILED;
  }

  /**
   * Cancel the refund.
   */
  public function cancel(): void {
    $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_DELETE,
      $this->links->self->href
    );
  }
}
