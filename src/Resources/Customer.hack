namespace Mollie\Api\Resources;

use namespace HH\Lib\Dict;
use type Mollie\Api\MollieApiClient;
use function json_encode;

class Customer extends BaseResource {
  public string $resource;

  /**
   * Id of the customer.
   */
  public string $id;

  /**
   * Either "live" or "test". Indicates this being a test or a live(verified) customer.
   */
  public string $mode;

  public string $name;

  public string $email;

  public ?string $locale;

  /**
   * @var \stdClass|mixed|null
   * TODO
   */
  public mixed $metadata;

  public vec<string> $recentlyUsedMethods;

  public string $createdAt;

  public Links $links;

  /**
   * @return Customer
   */
  public function update(): this {
    if($this->links->self !== null) {
      return $this;
    }

    $body = json_encode(dict[
      'name' => $this->name,
      'email' => $this->email,
      'locale' => $this->locale,
      'metadata' => $this->metadata
    ]);

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $this->links->self->href, $body);

    return ResourceFactory::createFromApiResult($result, new Customer($this->client));
  }

  public function createPayment(
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Payment {
    return $this->client->customerPayments->createFor($this, $this->withPresetOptions($options), $filters);
  }

  /**
   * Get all payments for this customer
   */
  public function payments(): PaymentCollection {
    return $this->client->customerPayments->listFor($this, null, null, $this->getPresetOptions());
  }

  public function createSubscription(
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Subscription {
    return $this->client->subscriptions->createFor($this, $this->withPresetOptions($options), $filters);
  }

  public function getSubscription(
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Subscription {
    return $this->client->subscriptions->getFor($this, $subscriptionId, $this->withPresetOptions($parameters));
  }

  public function cancelSubscription(
    string $subscriptionId
  ): void {
    $this->client->subscriptions->cancelFor($this, $subscriptionId, $this->getPresetOptions());
  }

  /**
   * Get all subscriptions for this customer
   */
  public function subscriptions(): SubscriptionCollection {
    return $this->client->subscriptions->listFor($this, null, null, $this->getPresetOptions());
  }

  public function createMandate(
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Mandate {
    return $this->client->mandates->createFor($this, $this->withPresetOptions($options), $filters);
  }

  public function getMandate(
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Mandate {
    return $this->client->mandates->getFor($this, $mandateId, $parameters);
  }

  public function revokeMandate(
    string $mandateId
  ): void {
    $this->client->mandates->revokeFor($this, $mandateId, $this->getPresetOptions());
  }

  /**
   * Get all mandates for this customer
   */
  public function mandates(): MandateCollection {
    return $this->client->mandates->listFor($this, null, null, $this->getPresetOptions());
  }

  /**
   * Helper function to check for mandate with status valid
   */
  public function hasValidMandate(): bool {
    $mandates = $this->mandates();
    foreach($mandates as $mandate) {
      if($mandate->isValid()) {
        return true;
      }
    }

    return false;
  }

  /**
   * Helper function to check for specific payment method mandate with status valid
   */
  public function hasValidMandateForMethod(
    string $method
  ): bool {
    $mandates = $this->mandates();
    foreach($mandates as $mandate) {
      if($mandate->method === $method && $mandate->isValid()) {
        return true;
      }
    }

    return false;
  }

  /**
   * When accessed by oAuth we want to pass the testmode by default
   */
  private function getPresetOptions(): dict<arraykey, bool> {
    $options = dict[];
    if($this->client->usesOAuth()) {
      $options["testmode"] = $this->mode === "test" ? true : false;
    }

    return $options;
  }

  /**
   * Apply the preset options.
   */
  private function withPresetOptions(
    dict<arraykey, mixed> $options
  ): dict<arraykey, mixed> {
    return Dict\merge($this->getPresetOptions(), $options);
  }
}
