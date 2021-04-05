namespace Mollie\Api\Resources;

class OrderCollection extends CursorCollection<Order> {
  public function getCollectionResourceName(): string {
  return 'orders';
  }

  protected function createResourceObject(): Order {
  return new Order($this->client);
  }
}
