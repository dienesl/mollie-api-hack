namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class PaymentRefundEndpoint extends CollectionEndpointAbstract<Resources\Refund, Resources\RefundCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'payments_refunds';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Refund {
    return new Resources\Refund($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
    protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\RefundCollection {
    return new Resources\RefundCollection($this->client, $count, $links);
  }

  public function getForAsync(
    Resources\Payment $payment,
    string $refundId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Refund> {
    return $this->getForIdAsync($payment->id, $refundId, $parameters);
  }

  public function getForIdAsync(
    string $paymentId,
    string $refundId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Refund> {
    $this->parentId = $paymentId;

    return $this->restReadAsync($refundId, $parameters);
  }

  public function listForAsync(
    Resources\Payment $payment,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\RefundCollection> {
    return $this->listForIdAsync($payment->id, $parameters);
  }

  public function listForIdAsync(
    string $paymentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\RefundCollection> {
    $this->parentId = $paymentId;

    return $this->restListAsync(null, null, $parameters);
  }
}
