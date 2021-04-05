namespace Mollie\Api\Endpoints;

use type Mollie\Api\Resources\ProfileCollection;

use namespace Mollie\Api\Resources;

class ProfileEndpoint extends CollectionEndpointAbstract<Resources\Profile, Resources\ProfileCollection> {
  private classname<Resources\Profile> $resourceClass = Resources\Profile::class;

  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'profiles';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Profile {
    $class = $this->resourceClass;
    return new $class($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\ProfileCollection {
    return new ProfileCollection($this->client, $count, $links);
  }

  /**
   * Creates a Profile in Mollie.
   */
  public function createAsync(
    dict<arraykey, mixed> $data = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Profile> {
    return $this->restCreateAsync($data, $filters);
  }

  /**
   * Retrieve a Profile from Mollie.
   *
   * Will throw an ApiException if the profile id is invalid or the resource cannot be found.
   */
  public function getAsync(
    string $profileId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Profile> {
    if($profileId === 'me') {
      return $this->getCurrentAsync($parameters);
    } else {
      return $this->restReadAsync($profileId, $parameters);
    }
  }

  /**
   * Retrieve the current Profile from Mollie.
   */
  public function getCurrentAsync(
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Profile> {
    $this->resourceClass = Resources\CurrentProfile::class;

    return $this->restReadAsync('me', $parameters);
  }

  /**
   * Delete a Profile from Mollie.
   *
   * Will throw a ApiException if the profile id is invalid or the resource cannot be found.
   * Returns with HTTP status No Content(204) if successful.
   */
  public function deleteAsync(
    string $profileId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Profile> {
    return $this->restDeleteAsync($profileId, $data);
  }

  /**
   * Retrieves a collection of Profiles from Mollie.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\ProfileCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }
}
