namespace Mollie\Api\Resources;

class SettlementCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'settlements';
  }

  protected function createResourceObject(): BaseResource {
    return new Settlement($this->client);
  }
}
