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
  protected function getResourceObject(): Resources\Chargeback {
  return new Resources\Chargeback($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  protected function getResourceCollectionObject(
  int $count,
  Resources\Links $links
  ): Resources\ChargebackCollection {
  return new Resources\ChargebackCollection($this->client, $count, $links);
  }

  public function getFor(
  Resources\Payment $payment,
  string $chargebackId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Chargeback {
  return $this->getForId($payment->id, $chargebackId, $parameters);
  }

  public function getForId(
  string $paymentId,
  string $chargebackId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Chargeback {
  $this->parentId = $paymentId;

  return $this->restRead($chargebackId, $parameters);
  }
}
