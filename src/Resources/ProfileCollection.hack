namespace Mollie\Api\Resources;

class ProfileCollection extends CursorCollection<Profile> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'profiles';
  }

  <<__Override>>
  protected function createResourceObject(): Profile {
    return new Profile($this->client);
  }
}
