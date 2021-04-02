namespace Mollie\Api\Resources;

class SubscriptionCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'subscriptions';
  }

  protected function createResourceObject(): BaseResource {
    return new Subscription($this->client);
  }
}
