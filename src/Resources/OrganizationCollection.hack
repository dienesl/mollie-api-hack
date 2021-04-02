namespace Mollie\Api\Resources;

class OrganizationCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'organizations';
  }

  protected function createResourceObject(): BaseResource {
    return new Organization($this->client);
  }
}
