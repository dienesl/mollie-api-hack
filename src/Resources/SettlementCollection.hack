namespace Mollie\Api\Resources;

class SettlementCollection extends CursorCollection<Settlement> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'settlements';
  }

  <<__Override>>
  protected function createResourceObject(): Settlement {
    return new Settlement($this->client);
  }
}
