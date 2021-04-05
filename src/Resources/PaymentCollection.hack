namespace Mollie\Api\Resources;

class PaymentCollection extends CursorCollection<Payment> {
  public function getCollectionResourceName(): string {
  return 'payments';
  }

  protected function createResourceObject(): Payment {
  return new Payment($this->client);
  }
}
