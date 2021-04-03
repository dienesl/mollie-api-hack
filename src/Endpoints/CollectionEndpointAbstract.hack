namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

abstract class CollectionEndpointAbstract<T1 as Resources\BaseResource, T2 as Resources\BaseCollection> extends EndpointAbstract<T1, T2> {
  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  abstract protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): T2;
}
