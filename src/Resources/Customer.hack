namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Dict
};
use type Mollie\Api\MollieApiClient;
use function Mollie\Api\Functions\to_dict;
use function json_encode;

class Customer extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the customer.
   */
  <<__LateInit>>
  public string $id;

  /**
   * Either "live" or "test". Indicates this being a test or a live(verified) customer.
   */
  <<__LateInit>>
  public string $mode;

  <<__LateInit>>
  public string $name;

  <<__LateInit>>
  public string $email;

  public ?string $locale;

  /**
   * @var \stdClass|mixed|null
   * TODO
   */
  public mixed $metadata;

  /*
   * TODO
   * probably it will vec<string>
   * i couldn't find it in the docs
   */
  public mixed $recentlyUsedMethods;

  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public Links $links;

  public function update(): Customer {
  $selfLink = $this->links->self;
  if($selfLink === null) {
    return $this;
  } else {
    $body = json_encode(dict[
    'name' => $this->name,
    'email' => $this->email,
    'locale' => $this->locale,
    'metadata' => $this->metadata
    ]);

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $selfLink->href, $body);

    return ResourceFactory::createFromApiResult($result, new Customer($this->client));
  }
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
  foreach($mandates->values as $mandate) {
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
  foreach($mandates->values as $mandate) {
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
    $options['testmode'] = $this->mode === 'test' ? true : false;
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

  <<__Override>>
  public function assert(
  dict<string, mixed>$datas
  ): void {
  $this->resource = (string)$datas['resource'];
  $this->id = (string)$datas['id'];
  $this->mode = (string)$datas['mode'];
  $this->name = (string)$datas['name'];
  $this->email = (string)$datas['email'];

  if(C\contains_key($datas, 'locale') && $datas['locale'] !== null) {
    $this->locale = (string)$datas['locale'];
  }

  $this->metadata = $datas['metadata'];

  $this->recentlyUsedMethods = $datas['recentlyUsedMethods'];

  $this->createdAt = (string)$datas['createdAt'];

  $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
