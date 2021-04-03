namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class OrderRefundEndpoint extends CollectionEndpointAbstract<Resources\Refund, Resources\RefundCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'orders_refunds';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Refund {
    return new Resources\Refund($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\RefundCollection {
    return new Resources\RefundCollection($this->client, $count, $links);
  }

  /**
   * Refund some order lines. You can provide an empty array for the
   * "lines" data to refund all eligible lines for this order.
   */
  public function createFor(
    Resources\Order $order,
    dict<arraykey, mixed> $data,
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Refund {
    return $this->createForId($order->id, $data, $filters);
  }

  /**
   * Refund some order lines. You can provide an empty array for the
   * "lines" data to refund all eligible lines for this order.
   */
  public function createForId(
    string $orderId,
    dict<arraykey, mixed> $data,
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Refund {
    $this->parentId = $orderId;

    return $this->restCreate($data, $filters);
  }
}
