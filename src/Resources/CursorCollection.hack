namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use function Mollie\Api\Functions\to_dict;

<<__ConsistentConstruct>>
abstract class CursorCollection<T as BaseResource> extends BaseCollection<T> {
  final public function __construct(
  protected MollieApiClient $client,
  int $count,
  Links $links
  ) {
  parent::__construct($count, $links);
  }

  abstract protected function createResourceObject(): T;

  /**
   * Return the next set of resources when available
   */
  final public function next(): ?CursorCollection<T> {
  $nextLink = $this->links->next;
  if($nextLink === null) {
    return null;
  } else {
    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $nextLink->href);

    $collection = new static(
    $this->client,
    (int)$result['count'],
    to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
    );

    $embedded = $result['_embedded'][$collection->getCollectionResourceName()] ?? null;
    if($embedded is Traversable<_>) {
    foreach($embedded as $dataResult) {
      $collection->values[] = ResourceFactory::createFromApiResult(to_dict($dataResult), $this->createResourceObject());
    }
    }

    return $collection;
  }
  }

  /**
   * Return the previous set of resources when available
   */
  final public function previous(): ?CursorCollection<T> {
  $previousLink = $this->links->previous;
  if($previousLink === null) {
    return null;
  } else {
    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $previousLink->href);

    $collection = new static(
    $this->client,
    (int)$result['count'],
    to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
    );

    $embedded = $result['_embedded'][$collection->getCollectionResourceName()] ?? null;
    if($embedded is Traversable<_>) {
    foreach($embedded as $dataResult) {
      $collection->values[] = ResourceFactory::createFromApiResult(to_dict($dataResult), $this->createResourceObject());
    }
    }

    return $collection;
  }
  }

  /**
   * Determine whether the collection has a next page available.
   */
  public function hasNext(): bool {
  return $this->links->next !== null;
  }

  /**
   * Determine whether the collection has a previous page available.
   */
  public function hasPrevious(): bool {
  return $this->links->previous !== null;
  }
}
