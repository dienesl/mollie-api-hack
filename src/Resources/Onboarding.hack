namespace Mollie\Api\Resources;

use type Mollie\Api\Types\OnboardingStatus;
use function Mollie\Api\Functions\to_dict;

class Onboarding extends BaseResource {
  <<__LateInit>>
  public string $resource;

  <<__LateInit>>
  public string $name;

  <<__LateInit>>
  public string $signedUpAt;

  /**
   * Either "needs-data", "in-review" or "completed".
   * Indicates this current status of the organization’s onboarding process.
   */
  <<__LateInit>>
  public OnboardingStatus $status;

  <<__LateInit>>
  public bool $canReceivePayments;

  <<__LateInit>>
  public bool $canReceiveSettlements;

  <<__LateInit>>
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

  <<__Override>>
    public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->name = (string)$datas['name'];
    $this->signedUpAt = (string)$datas['signedUpAt'];

    $this->status = OnboardingStatus::assert((string)$datas['signedUpAt']);

    $this->canReceivePayments = (bool)$datas['canReceivePayments'];
    $this->canReceiveSettlements = (bool)$datas['canReceiveSettlements'];

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
