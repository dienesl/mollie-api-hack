namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class ChargebackEndpoint extends CollectionEndpointAbstract<Resources\Chargeback, Resources\ChargebackCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'chargebacks';
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

  /**
   * Retrieves a collection of Chargebacks from Mollie.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\ChargebackCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }
}
