namespace Mollie\Api\Resources;

use type Mollie\Api\Types\OnboardingStatus;

class Onboarding extends BaseResource {
  public string $resource;

  public string $name;

  public string $signedUpAt;

  /**
   * Either "needs-data", "in-review" or "completed".
   * Indicates this current status of the organization’s onboarding process.
   */
  public OnboardingStatus $status;

  public bool $canReceivePayments;

  public bool $canReceiveSettlements;

  public Links $links;

  public function needsData(): bool {
    return $this->status === OnboardingStatus::NEEDS_DATA;
  }

  public function isInReview(): bool {
    return $this->status === OnboardingStatus::IN_REVIEW;
  }

  public function isCompleted(): bool {
    return $this->status === OnboardingStatus::COMPLETED;
  }
}
