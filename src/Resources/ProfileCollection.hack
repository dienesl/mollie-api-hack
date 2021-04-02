namespace Mollie\Api\Resources;

class ProfileCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'profiles';
  }

  protected function createResourceObject(): BaseResource {
    return new Profile($this->client);
  }
}
