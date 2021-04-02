namespace Mollie\Api\Resources;

class ChargebackCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'chargebacks';
  }

  protected function createResourceObject(): BaseResource {
    return new Chargeback($this->client);
  }
}
