namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class ShipmentEndpoint extends CollectionEndpointAbstract<Resources\Shipment, Resources\ShipmentCollection> {
  const string RESOURCE_ID_PREFIX = 'shp_';

  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'orders_shipments';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Shipment {
    return new Resources\Shipment($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API
   * endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\ShipmentCollection {
    return new Resources\ShipmentCollection($count, $links);
  }

  /**
   * Create a shipment for some order lines. You can provide an empty array for the
   * "lines" option to include all unshipped lines for this order.
   */
  public function createForAsync(
    Resources\Order $order,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Shipment> {
    return $this->createForIdAsync($order->id, $options, $filters);
  }

  /**
   * Create a shipment for some order lines. You can provide an empty array for the
   * "lines" option to include all unshipped lines for this order.
   */
  public function createForIdAsync(
    string $orderId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Shipment> {
    $this->parentId = $orderId;

    return $this->restCreateAsync($options, $filters);
  }

  /**
   * Retrieve a single shipment and the order lines shipped by a shipment’s ID.
   */
  public function getForAsync(
    Resources\Order $order,
    string $shipmentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Shipment> {
    return $this->getForIdAsync($order->id, $shipmentId, $parameters);
  }

  /**
   * Retrieve a single shipment and the order lines shipped by a shipment’s ID.
   */
  public function getForIdAsync(
    string $orderId,
    string $shipmentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Shipment> {
    $this->parentId = $orderId;

    return $this->restReadAsync($shipmentId, $parameters);
  }

  /**
   * Return all shipments for the Order provided.
   */
  public function listForAsync(
    Resources\Order $order,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\ShipmentCollection> {
    return $this->listForIdAsync($order->id, $parameters);
  }

  /**
   * Return all shipments for the provided Order id.
   */
  public function listForIdAsync(
    string $orderId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\ShipmentCollection> {
    $this->parentId = $orderId;

    return $this->restListAsync(null, null, $parameters);
  }
}
