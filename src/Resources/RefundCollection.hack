namespace Mollie\Api\Resources;

class RefundCollection extends CursorCollection<Refund> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'refunds';
  }

  <<__Override>>
  protected function createResourceObject(): Refund {
    return new Refund($this->client);
  }
}
