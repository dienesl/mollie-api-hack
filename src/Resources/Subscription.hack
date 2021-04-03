namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\SubscriptionStatus;
use function json_encode;

class Subscription extends BaseResource {
  <<__LateInit>>
  public string $resource;

  <<__LateInit>>
  public string $id;

  <<__LateInit>>
  public string $customerId;

  /**
   * Either "live" or "test" depending on the customer's mode.
   */
  <<__LateInit>>
  public string $mode;

  /**
   * UTC datetime the subscription created in ISO-8601 format.
   */
  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public string $status;

  /**
   * @var \stdClass
   * TODO
   */
  <<__LateInit>>
  public mixed $amount;

  public ?int $times;

  <<__LateInit>>
  public string $interval;

  <<__LateInit>>
  public string $description;

  public ?string $method;

  public ?string $mandateId;

  public ?dict<arraykey, mixed> $metadata;

  /**
   * UTC datetime the subscription canceled in ISO-8601 format.
   */
  public ?string $canceledAt;

  /**
   * Date the subscription started. For example: 2018-04-24
   */
  public ?string $startDate;

  /**
   * Contains an optional 'webhookUrl'.
   *
   * @var \stdClass|null
   * TODO
   */
  <<__LateInit>>
  public mixed $webhookUrl;
  
  /**
   * Date the next subscription payment will take place. For example: 2018-04-24
   */
  public ?string $nextPaymentDate;

  <<__LateInit>>
  public Links $links;

  public function update(): Subscription {
    if($this->links->self === null) {
      return $this;
    }

    $body = json_encode(dict[
      'amount' => $this->amount,
      'times' => $this->times,
      'startDate' => $this->startDate,
      'webhookUrl' => $this->webhookUrl,
      'description' => $this->description,
      'mandateId' => $this->mandateId,
      'metadata' => $this->metadata,
      'interval' => $this->interval,
    ]);

    $result = $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_PATCH,
      $this->links->self->href,
      $body
    );

    return ResourceFactory::createFromApiResult($result, new Subscription($this->client));
  }

  /**
   * Returns whether the Subscription is active or not.
   */
  public function isActive(): bool {
    return $this->status === SubscriptionStatus::STATUS_ACTIVE;
  }

  /**
   * Returns whether the Subscription is pending or not.
   */
  public function isPending(): bool {
    return $this->status === SubscriptionStatus::STATUS_PENDING;
  }

  /**
   * Returns whether the Subscription is canceled or not.
   */
  public function isCanceled(): bool {
    return $this->status === SubscriptionStatus::STATUS_CANCELED;
  }

  /**
   * Returns whether the Subscription is suspended or not.
   */
  public function isSuspended(): bool {
    return $this->status === SubscriptionStatus::STATUS_SUSPENDED;
  }

  /**
   * Returns whether the Subscription is completed or not.
   */
  public function isCompleted(): bool {
    return $this->status === SubscriptionStatus::STATUS_COMPLETED;
  }

  /**
   * Cancels this subscription
   */
  public function cancel(): Subscription {
    if($this->links->self === null) {
      return $this;
    }

    $body = null;
    if($this->client->usesOAuth()) {
      $body = json_encode(dict[
        'testmode' => $this->mode === 'test' ? true : false,
      ]);
    }

    $result = $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_DELETE,
      $this->links->self->href,
      $body
    );

    return ResourceFactory::createFromApiResult($result, new Subscription($this->client));
  }

  public function payments(): PaymentCollection {
    if($this->links->payments === null) {
      return new PaymentCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_GET,
      $this->links->payments->href
    );

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['payments'] ?? vec[],
      Payment::class,
      $result->links
    );
  }
}
