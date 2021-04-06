namespace Mollie\Api\Resources;

class ChargebackCollection extends CursorCollection<Chargeback> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'chargebacks';
  }

  <<__Override>>
  protected function createResourceObject(): Chargeback {
    return new Chargeback($this->client);
  }
}
