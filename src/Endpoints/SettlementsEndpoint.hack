namespace Mollie\Api\Endpoints;

use Mollie\Api\Exceptions\ApiException;
use Mollie\Api\Resources\Settlement;
use Mollie\Api\Resources\SettlementCollection;

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
  public function get(
    string $settlementId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Settlement {
    return $this->restRead($settlementId, $parameters);
  }

  /**
   * Retrieve the details of the current settlement that has not yet been paid out.
   */
  public function next(): Resources\Settlement {
    return $this->restRead('next', dict[]);
  }

  /**
   * Retrieve the details of the open balance of the organization.
   */
  public function open(): Resources\Settlement {
    return $this->restRead('open', dict[]);
  }

  /**
   * Retrieves a collection of Settlements from Mollie.
   */
  public function page(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\SettlementCollection {
    return $this->restList($from, $limit, $parameters);
  }
}
