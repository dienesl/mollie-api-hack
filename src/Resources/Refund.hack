namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\Types\{
  HttpMethod,
  RefundStatus
};
use function Mollie\Api\Functions\to_dict;

class Refund extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the payment method.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The $amount that was refunded.
   */
  <<__LateInit>>
  public Amount $amount;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  <<__LateInit>>
  public string $createdAt;

  /**
   * The refund's description, if available.
   */
  public ?string $description;

  /**
   * The payment id that was refunded.
   */
  <<__LateInit>>
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
   * TODO, what is this?
   */
  public mixed $lines;

  /**
   * The settlement amount
   */
  public ?Amount $settlementAmount;

  /**
   * The refund status
   */
  <<__LateInit>>
  public RefundStatus $status;

  <<__LateInit>>
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
  public async function cancelAsync(): Awaitable<void> {
    $selfLink = $this->links->self;
    if($selfLink !== null) {
      await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::DELETE,
        $selfLink->href
      );
    }
    throw new ApiException('self link is not setted,');
  }

  <<__Override>>
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];

    $this->amount = to_dict($datas['amount']) |> Amount::assert($$);

    $this->createdAt = (string)$datas['createdAt'];

    if(C\contains_key($datas, 'description') && $datas['description'] !== null) {
      $this->description = (string)$datas['description'];
    }

    $this->paymentId = (string)$datas['paymentId'];

    if(C\contains_key($datas, 'orderId') && $datas['orderId'] !== null) {
      $this->orderId = (string)$datas['orderId'];
    }

    $this->lines = $datas['lines'];

    if(C\contains_key($datas, 'settlementAmount') && $datas['settlementAmount'] !== null) {
      $this->settlementAmount = to_dict($datas['settlementAmount']) |> Amount::assert($$);
    }

    $this->status = RefundStatus::assert((string)$datas['status']);

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
