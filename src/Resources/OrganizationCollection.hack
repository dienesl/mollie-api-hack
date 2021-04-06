namespace Mollie\Api\Resources;

class OrganizationCollection extends CursorCollection<Organization> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'organizations';
  }

  <<__Override>>
  protected function createResourceObject(): Organization {
    return new Organization($this->client);
  }
}
