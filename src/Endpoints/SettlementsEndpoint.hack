namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class SettlementsEndpoint extends CollectionEndpointAbstract<Resources\Settlement, Resources\SettlementCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'settlements';
  }

  /**
   * Get the object that is used by this API. Every API uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Settlement {
    return new Resources\Settlement($this->client);
  }

  /**
   * Get the collection object that is used by this API. Every API uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\SettlementCollection {
    return new Resources\SettlementCollection($this->client, $count, $links);
  }

  /**
   * Retrieve a single settlement from Mollie.
   *
   * Will throw a ApiException if the settlement id is invalid or the resource cannot be found.
   */
  public function getAsync(
    string $settlementId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Settlement> {
    return $this->restReadAsync($settlementId, $parameters);
  }

  /**
   * Retrieve the details of the current settlement that has not yet been paid out.
   */
  public function nextAsync(): Awaitable<Resources\Settlement> {
    return $this->restReadAsync('next', dict[]);
  }

  /**
   * Retrieve the details of the open balance of the organization.
   */
  public function openAsync(): Awaitable<Resources\Settlement> {
    return $this->restReadAsync('open', dict[]);
  }

  /**
   * Retrieves a collection of Settlements from Mollie.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\SettlementCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }
}
