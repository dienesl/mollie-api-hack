namespace Mollie\Api\Resources;

class OnboardingCollection extends CursorCollection<Onboarding> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'onboarding';
  }

  <<__Override>>
  protected function createResourceObject(): Onboarding {
  return new Onboarding($this->client);
  }
}
