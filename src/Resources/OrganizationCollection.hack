namespace Mollie\Api\Resources;

class OrganizationCollection extends CursorCollection<Organization> {
  public function getCollectionResourceName(): string {
  return 'organizations';
  }

  protected function createResourceObject(): Organization {
  return new Organization($this->client);
  }
}
