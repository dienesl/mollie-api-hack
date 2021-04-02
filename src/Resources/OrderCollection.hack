namespace Mollie\Api\Resources;

class OrderCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'orders';
  }

  protected function createResourceObject(): BaseResource {
    return new Order($this->client);
  }
}
