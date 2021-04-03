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
  public function createFor(
    Resources\Order $order,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Shipment {
    return $this->createForId($order->id, $options, $filters);
  }

  /**
   * Create a shipment for some order lines. You can provide an empty array for the
   * "lines" option to include all unshipped lines for this order.
   */
  public function createForId(
    string $orderId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Shipment {
    $this->parentId = $orderId;

    return $this->restCreate($options, $filters);
  }

  /**
   * Retrieve a single shipment and the order lines shipped by a shipment’s ID.
   */
  public function getFor(
    Resources\Order $order,
    string $shipmentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Shipment {
    return $this->getForId($order->id, $shipmentId, $parameters);
  }

  /**
   * Retrieve a single shipment and the order lines shipped by a shipment’s ID.
   */
  public function getForId(
    string $orderId,
    string $shipmentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Shipment {
    $this->parentId = $orderId;

    return $this->restRead($shipmentId, $parameters);
  }

  /**
   * Return all shipments for the Order provided.
   */
  public function listFor(
    Resources\Order $order,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\ShipmentCollection {
    return $this->listForId($order->id, $parameters);
  }

  /**
   * Return all shipments for the provided Order id.
   */
  public function listForId(
    string $orderId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\ShipmentCollection {
    $this->parentId = $orderId;

    return $this->restList(null, null, $parameters);
  }
}
