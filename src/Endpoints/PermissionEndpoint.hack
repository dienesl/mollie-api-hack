namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class PermissionEndpoint extends CollectionEndpointAbstract<Resources\Permission, Resources\PermissionCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'permissions';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one
   * type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Permission {
    return new Resources\Permission($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API
   * endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\PermissionCollection {
    return new Resources\PermissionCollection($count, $links);
  }

  /**
   * Retrieve a single Permission from Mollie.
   *
   * Will throw an ApiException if the permission id is invalid.
   */
  public function getAsync(
    string $permissionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Permission> {
    return $this->restReadAsync($permissionId, $parameters);
  }

  /**
   * Retrieve all permissions.
   */
  public function allAsync(
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\PermissionCollection> {
    return $this->restListAsync(null, null, $parameters);
  }
}
