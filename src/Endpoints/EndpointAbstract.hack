namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;
use namespace HH\Lib\{
  C,
  Dict,
  Str
};
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\RestMethod;
use type Mollie\Api\Exceptions\ApiException;
use function http_build_query;
use function json_encode;
use function urlencode;

abstract class EndpointAbstract<T1 as Resources\BaseResource, T2 as Resources\BaseCollection> {
  <<__LateInit>>
  protected string $resourcePath;

  protected ?string $parentId;

  public function __construct(
    protected MollieApiClient $client
  ) {
    $this->setResourcePath();
  }

  protected function buildQueryString(
    dict<arraykey, mixed> $filters
  ): string {
    if(C\count($filters) === 0) {
      return '';
    }

    return '?' .(
      Dict\map_with_key($filters,
       ($key, $value) ==> dict[$key => $value is bool ? ($value ? 'true' : false) : $value]
      )
      |> http_build_query($$, '', '&')
    );
  }

  protected function restCreate(
    dict<arraykey, mixed> $body,
    dict<arraykey, mixed> $filters
  ): T1 {
    $result = $this->client->performHttpCall(
      RestMethod::CREATE,
      $this->getResourcePath() . $this->buildQueryString($filters),
      $this->parseRequestBody($body)
    );

    return Resources\ResourceFactory::createFromApiResult($result, $this->getResourceObject());
  }

  /**
   * Retrieves a single object from the REST API.
   */
  protected function restRead(
    string $id,
    dict<arraykey, mixed> $filters
  ): T1 {
    if(Str\is_empty($id)) {
      throw new ApiException('Invalid resource id.');
    }

    $id = urlencode($id);
    $result = $this->client->performHttpCall(
      RestMethod::READ,
      $this->getResourcePath() . '/' . $id . $this->buildQueryString($filters)
    );

    return Resources\ResourceFactory::createFromApiResult($result, $this->getResourceObject());
  }

  /**
   * Sends a DELETE request to a single Molle API object.
   */
  protected function restDelete(
    string $id,
    dict<arraykey, mixed> $body = dict[]
  ): ?T1 {
    if(Str\is_empty($id)) {
      throw new ApiException("Invalid resource id.");
    }

    $id = urlencode($id);
    $result = $this->client->performHttpCall(
      RestMethod::DELETE,
      $this->getResourcePath() . '/' . $id,
      $this->parseRequestBody($body)
    );

    if($result === null) {
      return null;
    }

    return Resources\ResourceFactory::createFromApiResult($result, $this->getResourceObject());
  }

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

    /** @var BaseCollection $collection */
    // TODO
    $collection = $this->getResourceCollectionObject($result->count, $result->links);

    foreach($result->_embedded->{$collection->getCollectionResourceName()} as $dataResult) {
      $collection[] = ResourceFactory::createFromApiResult($dataResult, $this->getResourceObject());
    }

    return $collection;
  }

  /*
  TODO
  public function setResourcePath(
    string $resourcePath
  ): void {
    $this->resourcePath = Str\lowercase($resourcePath);
  }
  */

  public function getResourcePath(): string {
    if(Str\contains($this->resourcePath, '_') !== false) {
      list($parentResource, $childResource) = Str\split($this->resourcePath, '_', 2);

      if(Str\is_empty($this->parentId)) {
        throw new ApiException('Subresource "' . $this->resourcePath . '" used without parent ' . $parentResource . '\' ID.');
      }

      return $parentResource . '/' .$this->parentId . '/' . $childResource;
    }

    return $this->resourcePath;
  }

  protected function parseRequestBody(
    dict<arraykey, mixed> $body
  ): ?string {
    if(C\count($body) === null) {
      return null;
    }

    return json_encode($body);
    /* TODO
    try {
      $encoded = \GuzzleHttp\json_encode($body);
    } catch(\InvalidArgumentException $e) {
      throw new ApiException("Error encoding parameters into JSON: '".$e->getMessage()."'.");
    }

    return $encoded;
    */
  }

  abstract protected function setResourcePath(): void;

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  abstract protected function getResourceObject(): T1;
}
