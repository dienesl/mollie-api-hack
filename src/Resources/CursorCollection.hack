namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;

<<__ConsistentConstruct>>
abstract class CursorCollection extends BaseCollection {
  final public function __construct(
    protected MollieApiClient $client,
    int $count,
    Links $links
  ) {
    parent::__construct($count, $links);
  }

  abstract protected function createResourceObject(): BaseResource;

  /**
   * Return the next set of resources when available
   */
  final public function next(): ?vec<CursorCollection> {
    if(!$this->hasNext()) {
      return null;
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->next->href);

    $collection = vec[new static($this->client, $result->count, $result->_links)];

    foreach($result->_embedded->{$collection->getCollectionResourceName()} as $dataResult) {
      $collection[] = ResourceFactory::createFromApiResult($dataResult, $this->createResourceObject());
    }

    return $collection;
  }

  /**
   * Return the previous set of resources when available
   */
  final public function previous(): ?vec<CursorCollection> {
    if(!$this->hasPrevious()) {
      return null;
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->previous->href);

    $collection = vec[new static($this->client, $result->count, $result->links)];

    foreach($result->_embedded->{$collection->getCollectionResourceName()} as $dataResult) {
      $collection[] = ResourceFactory::createFromApiResult($dataResult, $this->createResourceObject());
    }

    return $collection;
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
