namespace Mollie\Api\Resources;

class PaymentCollection extends CursorCollection<Payment> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'payments';
  }

  <<__Override>>
  protected function createResourceObject(): Payment {
  return new Payment($this->client);
  }
}
