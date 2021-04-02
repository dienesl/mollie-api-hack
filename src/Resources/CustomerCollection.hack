namespace Mollie\Api\Resources;

class CustomerCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'customers';
  }

  protected function createResourceObject(): BaseResource {
    return new Customer($this->client);
  }
}
