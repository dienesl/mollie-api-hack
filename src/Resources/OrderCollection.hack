namespace Mollie\Api\Resources;

class OrderCollection extends CursorCollection<Order> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'orders';
  }

  <<__Override>>
  protected function createResourceObject(): Order {
  return new Order($this->client);
  }
}
