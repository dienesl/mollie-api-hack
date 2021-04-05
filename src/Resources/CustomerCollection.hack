namespace Mollie\Api\Resources;

class CustomerCollection extends CursorCollection<Customer> {
  public function getCollectionResourceName(): string {
  return 'customers';
  }

  protected function createResourceObject(): Customer {
  return new Customer($this->client);
  }
}
