namespace Mollie\Api\Endpoints;

use namespace HH\Lib\C;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;
use function Mollie\Api\Functions\to_dict;
use function json_encode;
use function urlencode;

class ProfileMethodEndpoint extends CollectionEndpointAbstract<Resources\Method, Resources\MethodCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'profiles_methods';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Method {
    return new Resources\Method($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\MethodCollection {
    return new Resources\MethodCollection($count, $links);
  }

  /**
   * Enable a method for the provided Profile ID.
   */
  public async function createForIdAsync(
    string $profileId,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<Resources\Method> {
    $this->parentId = $profileId;
    $resource = $this->getResourcePath() . '/' . urlencode($methodId);

    $body = null;
    if(C\count($data) > 0) {
      $body = json_encode($data);
    }

    $result = await $this->client->performHttpCallAsync(
      RestMethod::CREATE,
      $resource,
      $body
    );

    return Resources\ResourceFactory::createFromApiResult(
      to_dict($result),
      new Resources\Method($this->client)
    );
  }

  /**
   * Enable a method for the provided Profile object.
   */
  public function createForAsync(
    Resources\Profile $profile,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<Resources\Method> {
    return $this->createForIdAsync($profile->id, $methodId, $data);
  }

  /**
   * Enable a method for the current profile.
   */
  public function createForCurrentProfileAsync(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<Resources\Method> {
    return $this->createForIdAsync('me', $methodId, $data);
  }

  /**
   * Disable a method for the provided Profile ID.
   */
  public function deleteForIdAsync(
    string $profileId,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Method> {
    $this->parentId = $profileId;

    return $this->restDeleteAsync($methodId, $data);
  }

  /**
   * Disable a method for the provided Profile object.
   */
  public function deleteForAsync(
    Resources\Profile $profile,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Resources\Method> {
    return $this->deleteForIdAsync($profile->id, $methodId, $data);
  }

  /**
   * Disable a method for the current profile.
   */
  public function deleteForCurrentProfileAsync(
    string $methodId,
    dict<arraykey, mixed> $data
  ): Awaitable<?Resources\Method> {
    return $this->deleteForIdAsync('me', $methodId, $data);
  }
}
