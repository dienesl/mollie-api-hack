namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Dict;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;

class SubscriptionEndpoint extends CollectionEndpointAbstract<Resources\Subscription, Resources\SubscriptionCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'customers_subscriptions';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Subscription {
    return new Resources\Subscription($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\SubscriptionCollection {
    return new Resources\SubscriptionCollection($this->client, $count, $links);
  }

  /**
   * Create a subscription for a Customer
   */
  public function createFor(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Subscription {
    return $this->createForId($customer->id, $options, $filters);
  }

  /**
   * Create a subscription for a Customer
   */
  public function createForId(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Subscription {
    $this->parentId = $customerId;

    return $this->restCreate($options, $filters);
  }

  public function getFor(
    Resources\Customer $customer,
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Subscription {
    return $this->getForId($customer->id, $subscriptionId, $parameters);
  }

  public function getForId(
    string $customerId,
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Subscription {
    $this->parentId = $customerId;

    return $this->restRead($subscriptionId, $parameters);
  }

  public function listFor(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\SubscriptionCollection {
    return $this->listForId($customer->id, $from, $limit, $parameters);
  }

  public function listForId(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\SubscriptionCollection {
    $this->parentId = $customerId;

    return $this->restList($from, $limit, $parameters);
  }

  public function cancelFor(
    Resources\Customer $customer,
    string $subscriptionId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Subscription {
    return $this->cancelForId($customer->id, $subscriptionId, $data);
  }

  public function cancelForId(
    string $customerId,
    string $subscriptionId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Subscription {
    $this->parentId = $customerId;

    return $this->restDelete($subscriptionId, $data);
  }

  /**
   * Retrieves a collection of Subscriptions from Mollie.
   *
   * @param string $from The first payment ID you want to include in your list.
   * @param int $limit
   * @param array $parameters
   *
   * @return SubscriptionCollection
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function page(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\SubscriptionCollection {
    $filters = Dict\merge(dict['from' => $from, 'limit' => $limit], $parameters);

    $apiPath = 'subscriptions' . $this->buildQueryString($filters);

    $result = $this->client->performHttpCall(RestMethod::LIST, $apiPath);

    $collection = $this->getResourceCollectionObject($result->count, $result->links);

    // TODO
    foreach($result->_embedded->{$collection->getCollectionResourceName()} as $dataResult) {
      $collection[] = Resources\ResourceFactory::createFromApiResult($dataResult, $this->getResourceObject());
    }

    return $collection;
  }
}
