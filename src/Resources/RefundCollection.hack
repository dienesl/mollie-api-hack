namespace Mollie\Api\Resources;

class RefundCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'refunds';
  }

  protected function createResourceObject(): BaseResource {
    return new Refund($this->client);
  }
}
