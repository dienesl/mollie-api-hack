namespace Mollie\Api\Resources;

class PaymentCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'payments';
  }

  protected function createResourceObject(): BaseResource {
    return new Payment($this->client);
  }
}
