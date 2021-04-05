namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class PaymentChargebackEndpoint extends CollectionEndpointAbstract<Resources\Chargeback, Resources\ChargebackCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'payments_chargebacks';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Chargeback {
    return new Resources\Chargeback($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\ChargebackCollection {
    return new Resources\ChargebackCollection($this->client, $count, $links);
  }

  public function getForAsync(
    Resources\Payment $payment,
    string $chargebackId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Chargeback> {
    return $this->getForIdAsync($payment->id, $chargebackId, $parameters);
  }

  public function getForIdAsync(
    string $paymentId,
    string $chargebackId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Chargeback> {
    $this->parentId = $paymentId;

    return $this->restReadAsync($chargebackId, $parameters);
  }
}
