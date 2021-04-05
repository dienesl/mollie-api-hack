namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class SettlementPaymentEndpoint extends CollectionEndpointAbstract<Resources\Payment, Resources\PaymentCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
  $this->resourcePath = 'settlements_payments';
  }

  <<__Override>>
  protected function getResourceObject(): Resources\Payment {
  return new Resources\Payment($this->client);
  }

  <<__Override>>
  protected function getResourceCollectionObject(
  int $count,
  Resources\Links $links
  ): Resources\PaymentCollection {
  return new Resources\PaymentCollection($this->client, $count, $links);
  }

  /**
   * Retrieves a collection of Payments from Mollie.
   */
  public function pageForId(
  string $settlementId,
  ?string $from = null,
  ?int $limit = null,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\PaymentCollection {
  $this->parentId = $settlementId;

  return $this->restList($from, $limit, $parameters);
  }
}
