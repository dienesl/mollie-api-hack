namespace Mollie\Api\Resources;

class SubscriptionCollection extends CursorCollection<Subscription> {
  public function getCollectionResourceName(): string {
    return 'subscriptions';
  }

  protected function createResourceObject(): Subscription {
    return new Subscription($this->client);
  }
}
