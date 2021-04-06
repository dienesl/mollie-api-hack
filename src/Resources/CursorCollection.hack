namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\HttpMethod;
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
  final public async function nextAsync(): Awaitable<?CursorCollection<T>> {
    $nextLink = $this->links->next;
    if($nextLink === null) {
      return null;
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(HttpMethod::GET, $nextLink->href);

      $collection = new static(
        $this->client,
        (int)$result['count'],
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );

      $resourceName = $collection->getCollectionResourceName();
      if($resourceName !== null) {
        $embedded = $result['_embedded'];
        if($embedded is KeyedContainer<_, _>) {
          $targetEmbedded = $embedded[$resourceName];
          if($targetEmbedded is Traversable<_>) {
            foreach($targetEmbedded as $dataResult) {
              $collection->values[] = ResourceFactory::createFromApiResult(to_dict($dataResult), $this->createResourceObject());
            }
          }
        }
      }

      return $collection;
    }
  }

  /**
   * Return the previous set of resources when available
   */
  final public async function previousAsync(): Awaitable<?CursorCollection<T>> {
    $previousLink = $this->links->previous;
    if($previousLink === null) {
      return null;
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(HttpMethod::GET, $previousLink->href);

      $collection = new static(
        $this->client,
        (int)$result['count'],
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );

      $resourceName = $this->getCollectionResourceName();
      if($resourceName !== null) {
        $embedded = $result['_embedded'];
        if($embedded is KeyedContainer<_, _>) {
          $targetEmbedded = $embedded[$resourceName] ?? null;
            if($targetEmbedded is Traversable<_>) {
            foreach($embedded as $dataResult) {
              $collection->values[] = ResourceFactory::createFromApiResult(to_dict($dataResult), $this->createResourceObject());
            }
          }
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
