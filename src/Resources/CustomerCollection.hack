namespace Mollie\Api\Resources;

class CustomerCollection extends CursorCollection<Customer> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'customers';
  }

  <<__Override>>
  protected function createResourceObject(): Customer {
    return new Customer($this->client);
  }
}
