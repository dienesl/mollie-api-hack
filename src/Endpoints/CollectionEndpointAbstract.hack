namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Dict;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;
use function Mollie\Api\Functions\to_dict;

abstract class CollectionEndpointAbstract<T1 as Resources\BaseResource, T2 as Resources\BaseCollection<T1>> extends EndpointAbstract<T1> {
  /**
   * Get a collection of objects from the REST API.
   */
  protected function restList(
  ?string $from = null,
  ?int $limit = null,
  dict<arraykey, mixed> $filters = dict[]
  ): T2 {
  $filters = Dict\merge<arraykey, mixed>(dict[
    'from' => $from,
    'limit' => $limit
  ], $filters);

  $apiPath = $this->getResourcePath() . $this->buildQueryString($filters);

  $result = $this->client->performHttpCall(RestMethod::LIST, $apiPath);

  $collection = $this->getResourceCollectionObject(
    (int)($result['count'] ?? 0),
    to_dict($result['_links'] ?? dict[]) |> Resources\Links::assert($$)
  );

  $embedded = $result['_embedded'][$collection->getCollectionResourceName()] ?? null;
  if($embedded is Traversable<_>) {
    foreach($embedded as $dataResult) {
    $collection->values[] = Resources\ResourceFactory::createFromApiResult(
      to_dict($dataResult),
      $this->getResourceObject()
    );
    }
  }

  return $collection;
  }
  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  abstract protected function getResourceCollectionObject(
  int $count,
  Resources\Links $links
  ): T2;
}
