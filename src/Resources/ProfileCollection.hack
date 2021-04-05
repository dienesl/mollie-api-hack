namespace Mollie\Api\Resources;

class ProfileCollection extends CursorCollection<Profile> {
  public function getCollectionResourceName(): string {
  return 'profiles';
  }

  protected function createResourceObject(): Profile {
  return new Profile($this->client);
  }
}
