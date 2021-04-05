namespace Mollie\Api\Endpoints;

use namespace HH\Lib\Str;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;

class OrganizationEndpoint extends CollectionEndpointAbstract<Resources\Organization, Resources\OrganizationCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'organizations';
  }

  <<__Override>>
  protected function getResourceObject(): Resources\Organization {
    return new Resources\Organization($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\OrganizationCollection {
    return new Resources\OrganizationCollection($this->client, $count, $links);
  }

  /**
   * Retrieve an organization from Mollie.
   *
   * Will throw a ApiException if the organization id is invalid or the resource cannot be found.
   */
  public function getAsync(
    string $organizationId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Organization> {
    if(Str\is_empty($organizationId)) {
      throw new ApiException('Organization ID is empty.');
    }

    return $this->restReadAsync($organizationId, $parameters);
  }

  /**
   * Retrieve the current organization from Mollie.
   */
  public function currentAsync(
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Organization> {
    return $this->restReadAsync('me', $parameters);
  }
}
