namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Dict;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;
use function Mollie\Api\Functions\to_dict;

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
  public function createForAsync(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Subscription> {
    return $this->createForIdAsync($customer->id, $options, $filters);
  }

  /**
   * Create a subscription for a Customer
   */
  public function createForIdAsync(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Subscription> {
    $this->parentId = $customerId;

    return $this->restCreateAsync($options, $filters);
  }

  public function getForAsync(
    Resources\Customer $customer,
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Subscription> {
    return $this->getForIdAsync($customer->id, $subscriptionId, $parameters);
  }

  public function getForIdAsync(
    string $customerId,
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Subscription> {
    $this->parentId = $customerId;

    return $this->restReadAsync($subscriptionId, $parameters);
  }

  public function listForAsync(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\SubscriptionCollection> {
    return $this->listForIdAsync($customer->id, $from, $limit, $parameters);
  }

  public function listForIdAsync(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\SubscriptionCollection> {
    $this->parentId = $customerId;

    return $this->restListAsync($from, $limit, $parameters);
  }

  public function cancelForAsync(
    Resources\Customer $customer,
    string $subscriptionId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Subscription> {
    return $this->cancelForIdAsync($customer->id, $subscriptionId, $data);
  }

  public function cancelForIdAsync(
    string $customerId,
    string $subscriptionId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Subscription> {
    $this->parentId = $customerId;

    return $this->restDeleteAsync($subscriptionId, $data);
  }

  /**
   * Retrieves a collection of Subscriptions from Mollie.
   *
   * @param string $from The first payment ID you want to include in your list.
   */
  public async function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\SubscriptionCollection> {
    $filters = Dict\merge(dict['from' => $from, 'limit' => $limit], $parameters);

    $apiPath = 'subscriptions' . $this->buildQueryString($filters);

    $result = await $this->client->performHttpCallAsync(RestMethod::LIST, $apiPath);

    $collection = $this->getResourceCollectionObject(
      (int)($result['count'] ?? 0),
      to_dict($result['_links'] ?? dict[]) |> Resources\Links::assert($$)
    );

    $resourceName = $collection->getCollectionResourceName();
    if($resourceName !== null) {
      if($resourceName !== null) {
        $embedded = $result['_embedded'] ?? null;
        if($embedded is KeyedContainer<_, _>) {
          $targetEmbedded = $embedded[$resourceName];
          if($targetEmbedded is Traversable<_>) {
            foreach($targetEmbedded as $dataResult) {
              $collection->values[] = Resources\ResourceFactory::createFromApiResult(
                to_dict($dataResult),
                $this->getResourceObject()
              );
            }
          }
        }
      }
    }

    return $collection;
  }
}
