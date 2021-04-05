namespace Mollie\Api\Resources;

class SettlementCollection extends CursorCollection<Settlement> {
  public function getCollectionResourceName(): string {
  return 'settlements';
  }

  protected function createResourceObject(): Settlement {
  return new Settlement($this->client);
  }
}
