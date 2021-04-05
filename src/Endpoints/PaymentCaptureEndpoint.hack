namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class PaymentCaptureEndpoint extends CollectionEndpointAbstract<Resources\Capture, Resources\CaptureCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'payments_captures';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Capture {
    return new Resources\Capture($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\CaptureCollection {
    return new Resources\CaptureCollection($this->client, $count, $links);
  }

  public function getForAsync(
    Resources\Payment $payment,
    string $captureId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Capture> {
    return $this->getForIdAsync($payment->id, $captureId, $parameters);
  }

  public function getForIdAsync(
    string $paymentId,
    string $captureId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Capture> {
    $this->parentId = $paymentId;

    return $this->restReadAsync($captureId, $parameters);
  }
}
