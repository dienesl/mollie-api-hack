namespace Mollie\Api\Resources;

class RefundCollection extends CursorCollection<Refund> {
  public function getCollectionResourceName(): string {
  return 'refunds';
  }

  protected function createResourceObject(): Refund {
  return new Refund($this->client);
  }
}
