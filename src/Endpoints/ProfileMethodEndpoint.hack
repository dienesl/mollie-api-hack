namespace Mollie\Api\Endpoints;

use namespace HH\Lib\C;
use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;
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
  public function createForId(
    string $profileId,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Resources\Method {
    $this->parentId = $profileId;
    $resource = $this->getResourcePath() . '/' . urlencode($methodId);

    $body = null;
    if(C\count($data) > 0) {
      $body = json_encode($data);
    }

    $result = $this->client->performHttpCall(RestMethod::CREATE, $resource, $body);

    return Resources\ResourceFactory::createFromApiResult($result, new Method($this->client));
  }

  /**
   * Enable a method for the provided Profile object.
   */
  public function createFor(
    Resources\Profile $profile,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Resources\Method {
    return $this->createForId($profile->id, $methodId, $data);
  }

  /**
   * Enable a method for the current profile.
   */
  public function createForCurrentProfile(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Resources\Method {
    return $this->createForId('me', $methodId, $data);
  }

  /**
   * Disable a method for the provided Profile ID.
   */
  public function deleteForId(
    string $profileId,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Method {
    $this->parentId = $profileId;

    return $this->restDelete($methodId, $data);
  }

  /**
   * Disable a method for the provided Profile object.
   */
  public function deleteFor(
    Resources\Profile $profile,
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Method {
    return $this->deleteForId($profile->id, $methodId, $data);
  }

  /**
   * Disable a method for the current profile.
   */
  public function deleteForCurrentProfile(
    string $methodId,
    dict<arraykey, mixed> $data
  ): ?Resources\Method {
    return $this->deleteForId('me', $methodId, $data);
  }
}
