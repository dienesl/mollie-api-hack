namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Str;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;

class OrderEndpoint extends CollectionEndpointAbstract<Resources\Order, Resources\OrderCollection> {
  const string RESOURCE_ID_PREFIX = 'ord_';

  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'orders';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one
   * type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Order {
    return new Resources\Order($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API
   * endpoint uses one type of collection object.
   */
  <<__Override>>
    protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\OrderCollection {
    return new Resources\OrderCollection($this->client, $count, $links);
  }

  /**
   * Creates a order in Mollie.
   */
  public function createAsync(
    dict<arraykey, mixed> $data = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Order> {
    return $this->restCreateAsync($data, $filters);
  }

  /**
   * Retrieve a single order from Mollie.
   *
   * Will throw a ApiException if the order id is invalid or the resource cannot
   * be found.
   */
  public function getAsync(
    string $orderId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Order> {
    if(Str\is_empty($orderId) || Str\search($orderId, self::RESOURCE_ID_PREFIX) !== 0) {
      throw new ApiException('Invalid order ID: \'' . $orderId . '\'. An order ID should start with \'' . self::RESOURCE_ID_PREFIX . '\'.');
    }

    return $this->restReadAsync($orderId, $parameters);
  }

  /**
   * Cancel the given Order.
   *
   * If the order was partially shipped, the status will be "completed" instead of
   * "canceled".
   * Will throw a ApiException if the order id is invalid or the resource cannot
   * be found.
   * Returns the canceled order with HTTP status 200.
   */
  public function cancelAsync(
    string $orderId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<?Resources\Order> {
    return $this->restDeleteAsync($orderId, $parameters);
  }

  /**
   * Retrieves a collection of Orders from Mollie.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\OrderCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }
}
