namespace Mollie\Api\Resources;

class SubscriptionCollection extends CursorCollection<Subscription> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'subscriptions';
  }

  <<__Override>>
  protected function createResourceObject(): Subscription {
  return new Subscription($this->client);
  }
}
