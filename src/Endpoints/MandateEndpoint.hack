namespace Mollie\Api\Endpoints;

use Mollie\Api\Resources;

class MandateEndpoint extends CollectionEndpointAbstract<Resources\Mandate, Resources\MandateCollection>{
  <<__Override>>
  protected function setResourcePath(): void {
    $resourcePath = 'customers_mandates';
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
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\MandateCollection {
    return new Resources\MandateCollection($this->client, $count, $links);
  }

  public function createFor(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Mandate {
    return $this->createForId($customer->id, $options, $filters);
  }

  public function createForId(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Mandate {
    $this->parentId = $customerId;

    return $this->restCreate($options, $filters);
  }

  public function getFor(
    Resources\Customer $customer,
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Mandate {
    return $this->getForId($customer->id, $mandateId, $parameters);
  }

  public function getForId(
    string $customerId,
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Mandate {
    $this->parentId = $customerId;

    return $this->restRead($mandateId, $parameters);
  }

  public function listFor(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\MandateCollection {
    return $this->listForId($customer->id, $from, $limit, $parameters);
  }

  public function listForId(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\MandateCollection {
    $this->parentId = $customerId;

    return $this->restList($from, $limit, $parameters);
  }

  public function revokeFor(
    Resources\Customer $customer,
    string $mandateId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Mandate {
    return $this->revokeForId($customer->id, $mandateId, $data);
  }

  public function revokeForId(
    string $customerId,
    string $mandateId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Mandate {
    $this->parentId = $customerId;

    return $this->restDelete($mandateId, $data);
  }
}
