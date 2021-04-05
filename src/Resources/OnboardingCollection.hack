namespace Mollie\Api\Resources;

class OnboardingCollection extends CursorCollection<Onboarding> {
  public function getCollectionResourceName(): string {
    return 'onboarding';
  }

  protected function createResourceObject(): Onboarding {
    return new Onboarding($this->client);
  }
}
