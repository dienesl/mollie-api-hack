namespace Mollie\Api\Resources;

class ChargebackCollection extends CursorCollection<Chargeback> {
  public function getCollectionResourceName(): string {
  return 'chargebacks';
  }

  protected function createResourceObject(): Chargeback {
  return new Chargeback($this->client);
  }
}
