namespace Mollie\Api\Endpoints;

use Mollie\Api\Exceptions\ApiException;
use Mollie\Api\Resources\CurrentProfile;
use Mollie\Api\Resources\Profile;
use Mollie\Api\Resources\ProfileCollection;

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
  public function create(
  dict<arraykey, mixed> $data = dict[],
  dict<arraykey, mixed> $filters = dict[]
  ): Resources\Profile {
  return $this->restCreate($data, $filters);
  }

  /**
   * Retrieve a Profile from Mollie.
   *
   * Will throw an ApiException if the profile id is invalid or the resource cannot be found.
   */
  public function get(
  string $profileId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Profile {
  if($profileId === 'me') {
    return $this->getCurrent($parameters);
  }

  return $this->restRead($profileId, $parameters);
  }

  /**
   * Retrieve the current Profile from Mollie.
   */
  public function getCurrent(
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Profile {
  $this->resourceClass = Resources\CurrentProfile::class;

  return $this->restRead('me', $parameters);
  }

  /**
   * Delete a Profile from Mollie.
   *
   * Will throw a ApiException if the profile id is invalid or the resource cannot be found.
   * Returns with HTTP status No Content(204) if successful.
   */
  public function delete(
  string $profileId,
  dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Profile {
  return $this->restDelete($profileId, $data);
  }

  /**
   * Retrieves a collection of Profiles from Mollie.
   */
  public function page(
  ?string $from = null,
  ?int $limit = null,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\ProfileCollection {
  return $this->restList($from, $limit, $parameters);
  }
}
