namespace Mollie\Api\Resources;

class OnboardingCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'onboarding';
  }

  protected function createResourceObject(): BaseResource {
    return new Onboarding($this->client);
  }
}
