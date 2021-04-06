namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Dict
};
use type Mollie\Api\Types\HttpMethod;
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

  public async function updateAsync(): Awaitable<Customer> {
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

      $result = await $this->client->performHttpCallToFullUrlAsync(HttpMethod::PATCH, $selfLink->href, $body);

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
  public function paymentsAsync(): Awaitable<PaymentCollection> {
    return $this->client->customerPayments->listForAsync($this, null, null, $this->getPresetOptions());
  }

  public function createSubscriptionAsync(
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Subscription> {
    return $this->client->subscriptions->createForAsync($this, $this->withPresetOptions($options), $filters);
  }

  public function getSubscriptionAsync(
    string $subscriptionId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Subscription> {
    return $this->client->subscriptions->getForAsync($this, $subscriptionId, $this->withPresetOptions($parameters));
  }

  public async function cancelSubscriptionAsync(
    string $subscriptionId
  ): Awaitable<void> {
    await $this->client->subscriptions->cancelForAsync($this, $subscriptionId, $this->getPresetOptions());
  }

  /**
   * Get all subscriptions for this customer
   */
  public function subscriptionsAsync(): Awaitable<SubscriptionCollection> {
    return $this->client->subscriptions->listForAsync($this, null, null, $this->getPresetOptions());
  }

  public function createMandateAsync(
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Mandate> {
    return $this->client->mandates->createForAsync($this, $this->withPresetOptions($options), $filters);
  }

  public function getMandateAsync(
    string $mandateId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Mandate> {
    return $this->client->mandates->getForAsync($this, $mandateId, $parameters);
  }

  public async function revokeMandateAsync(
    string $mandateId
  ): Awaitable<void> {
    await $this->client->mandates->revokeForAsync($this, $mandateId, $this->getPresetOptions());
  }

  /**
   * Get all mandates for this customer
   */
  public function mandatesAsync(): Awaitable<MandateCollection> {
    return $this->client->mandates->listForAsync($this, null, null, $this->getPresetOptions());
  }

  /**
   * Helper function to check for mandate with status valid
   */
  public async function hasValidMandateAsync(): Awaitable<bool> {
    $mandates = await $this->mandatesAsync();
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
  public async function hasValidMandateForMethodAsync(
    string $method
  ): Awaitable<bool> {
    $mandates = await $this->mandatesAsync();
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
