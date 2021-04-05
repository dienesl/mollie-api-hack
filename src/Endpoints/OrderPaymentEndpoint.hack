namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class OrderPaymentEndpoint extends CollectionEndpointAbstract<Resources\Payment, Resources\PaymentCollection> {
  const string RESOURCE_ID_PREFIX = 'tr_';

  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'orders_payments';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one
   * type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Payment {
    return new Resources\Payment($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API
   * endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\PaymentCollection {
    return new Resources\PaymentCollection($this->client, $count, $links);
  }

  /**
   * Creates a payment in Mollie for a specific order.
   */
  public function createForAsync(
    Resources\Order $order,
    dict<arraykey, mixed> $data,
    dict<arraykey, mixed> $filters
  ): Awaitable<Resources\Payment> {
    return $this->createForIdAsync($order->id, $data, $filters);
  }

  /**
   * Creates a payment in Mollie for a specific order ID.
   *
   * @param array $data An array containing details on the order payment.
   */
  public function createForIdAsync(
    string $orderId,
    dict<arraykey, mixed> $data,
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Payment> {
    $this->parentId = $orderId;

    return $this->restCreateAsync($data, $filters);
  }
}
