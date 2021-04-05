namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Str;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\Types\HttpMethod;
use function Mollie\Api\Functions\{
  to_dict,
  to_vec_dict
};

class MethodEndpoint extends CollectionEndpointAbstract<Resources\Method, Resources\MethodCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'methods';
  }

  protected function getResourceObject(): Resources\Method {
    return new Resources\Method($this->client);
  }

  /**
   * Retrieve all active methods. In test mode, this includes pending methods. The results are not paginated.
   */
  public function all(
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\MethodCollection {
    return $this->allActive($parameters);
  }

  /**
   * Retrieve all active methods for the organization. In test mode, this includes pending methods.
   * The results are not paginated.
   */
  public function allActive(
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\MethodCollection {
    return $this->restList(null, null, $parameters);
  }

  /**
   * Retrieve all available methods for the organization, including activated and not yet activated methods. The
   * results are not paginated. Make sure to include the profileId parameter if using an OAuth Access Token.
   */
  public function allAvailable(
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\MethodCollection {
    $url = 'methods/all' . $this->buildQueryString($parameters);

    $result = $this->client->performHttpCall(HttpMethod::GET as string, $url);

    return Resources\ResourceFactory::createBaseResourceCollection(
      $this->client,
      Resources\Method::class,
      Resources\MethodCollection::class,
      to_vec_dict($result['_embedded']['methods'] ?? vec[]),
      to_dict($result['_links'] ?? dict[]) |> Resources\Links::assert($$)
    );
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\MethodCollection {
    return new Resources\MethodCollection($count, $links);
  }

  /**
   * Retrieve a payment method from Mollie.
   *
   * Will throw a ApiException if the method id is invalid or the resource cannot be found.
   */
  public function get(
    string $methodId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Method {
    if(Str\is_empty($methodId)) {
      throw new ApiException('Method ID is empty.');
    }

    return $this->restRead($methodId, $parameters);
  }
}
