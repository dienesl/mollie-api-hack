namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class MandateEndpoint extends CollectionEndpointAbstract<Resources\Mandate, Resources\MandateCollection>{
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'customers_mandates';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Mandate {
    return new Resources\Mandate($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\MandateCollection {
    return new Resources\MandateCollection($this->client, $count, $links);
  }

  public function createForAsync(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Mandate> {
    return $this->createForIdAsync($customer->id, $options, $filters);
  }

  public function createForIdAsync(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Mandate> {
    $this->parentId = $customerId;

    return $this->restCreateAsync($options, $filters);
  }

  public function getForAsync(
    Resources\Customer $customer,
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Mandate> {
    return $this->getForIdAsync($customer->id, $mandateId, $parameters);
  }

  public function getForIdAsync(
    string $customerId,
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Mandate> {
    $this->parentId = $customerId;

    return $this->restReadAsync($mandateId, $parameters);
  }

  public function listForAsync(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\MandateCollection> {
    return $this->listForIdAsync($customer->id, $from, $limit, $parameters);
  }

  public function listForIdAsync(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\MandateCollection> {
    $this->parentId = $customerId;

    return $this->restListAsync($from, $limit, $parameters);
  }

  public function revokeForAsync(
    Resources\Customer $customer,
    string $mandateId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Mandate> {
    return $this->revokeForIdAsync($customer->id, $mandateId, $data);
  }

  public function revokeForIdAsync(
    string $customerId,
    string $mandateId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Mandate> {
    $this->parentId = $customerId;

    return $this->restDeleteAsync($mandateId, $data);
  }
}
