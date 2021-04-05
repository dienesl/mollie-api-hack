namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class CustomerEndpoint extends CollectionEndpointAbstract<Resources\Customer, Resources\CustomerCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'customers';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Customer {
    return new Resources\Customer($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\CustomerCollection {
    return new Resources\CustomerCollection($this->client, $count, $links);
  }

  /**
   * Creates a customer in Mollie.
   */
  public function create(
    dict<arraykey, mixed> $data = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Customer {
    return $this->restCreate($data, $filters);
  }

  /**
   * Retrieve a single customer from Mollie.
   *
   * Will throw a ApiException if the customer id is invalid or the resource cannot be found.
   */
  public function get(
    string $customerId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Customer {
    return $this->restRead($customerId, $parameters);
  }

  /**
   * Deletes the given Customer.
   *
   * Will throw a ApiException if the customer id is invalid or the resource cannot be found.
   * Returns with HTTP status No Content(204) if successful.
   */
  public function delete(
    string $customerId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\BaseResource {
    return $this->restDelete($customerId, $data);
  }

  /**
   * Retrieves a collection of Customers from Mollie.
   *
   * @param string $from The first customer ID you want to include in your list.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\CustomerCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }
}
