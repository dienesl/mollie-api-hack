namespace Mollie\Api\Endpoints;

use namespace HH\Lib\C;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\Types\RestMethod;

class OrderLineEndpoint extends CollectionEndpointAbstract<Resources\OrderLine, Resources\OrderLineCollection> {
  const string RESOURCE_ID_PREFIX = 'odl_';

  <<__Override>>
  protected function setResourcePath(): void {
  $this->resourcePath = 'orders_lines';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one
   * type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\OrderLine {
  return new Resources\OrderLine($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API
   * endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
  int $count,
  Resources\Links $links
  ): Resources\OrderLineCollection {
  return new Resources\OrderLineCollection($count, $links);
  }

  /**
   * Cancel lines for the provided order.
   * The data array must contain a lines array.
   * You can pass an empty lines array if you want to cancel all eligible lines.
   * Returns null if successful.
   */
  public function cancelFor(
  Resources\Order $order,
  dict<arraykey, mixed> $data
  ): void {
  $this->cancelForId($order->id, $data);
  }

  /**
   * Cancel lines for the provided order id.
   * The data array must contain a lines array.
   * You can pass an empty lines array if you want to cancel all eligible lines.
   * Returns null if successful.
   *
   * @param string $orderId
   * @param array $data
   *
   * @return null
   * @throws ApiException
   */
  public function cancelForId(
  string $orderId,
  dict<arraykey, mixed> $data
  ): void {
  // TODO
  // maybe change KeyedContainer to Iterator
  if(!C\contains($data, 'lines') || !$data['lines'] is KeyedContainer<_, _>) {
    throw new ApiException('A lines array is required.');
  }

  $this->parentId = $orderId;

  $this->client->performHttpCall(
    RestMethod::DELETE,
    $this->getResourcePath(),
    $this->parseRequestBody($data)
  );
  }
}
