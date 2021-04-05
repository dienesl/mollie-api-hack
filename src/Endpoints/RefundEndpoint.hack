namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class RefundEndpoint extends CollectionEndpointAbstract<Resources\Refund, Resources\RefundCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
  $this->resourcePath = 'refunds';
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
   * Retrieves a collection of Refunds from Mollie.
   */
  public function page(
  ?string $from = null,
  ?int $limit = null,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\RefundCollection {
  return $this->restList($from, $limit, $parameters);
  }
}
