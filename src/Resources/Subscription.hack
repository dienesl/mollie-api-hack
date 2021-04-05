namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\SubscriptionStatus;
use function Mollie\Api\Functions\to_dict;
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
  public SubscriptionStatus $status;

  <<__LateInit>>
  public Amount $amount;

  public ?int $times;

  <<__LateInit>>
  public string $interval;

  <<__LateInit>>
  public string $description;

  public ?string $method;

  public ?string $mandateId;

  // TODO
  // what is this?
  public mixed $metadata;

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
   */
  public ?string $webhookUrl;
  
  /**
   * Date the next subscription payment will take place. For example: 2018-04-24
   */
  public ?string $nextPaymentDate;

  <<__LateInit>>
  public Links $links;

  public function update(): Subscription {
    $selfLink = $this->links->self;
    if($selfLink === null) {
      return $this;
    } else {
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
        $selfLink->href,
        $body
      );

      return ResourceFactory::createFromApiResult($result, new Subscription($this->client));
    }
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
    $selfLink = $this->links->self;
    if($selfLink === null) {
      return $this;
    } else {
      $body = null;
      if($this->client->usesOAuth()) {
        $body = json_encode(dict[
          'testmode' => $this->mode === 'test' ? true : false,
        ]);
      }

      $result = $this->client->performHttpCallToFullUrl(
        MollieApiClient::HTTP_DELETE,
        $selfLink->href,
        $body
      );

      return ResourceFactory::createFromApiResult($result, new Subscription($this->client));
    }
  }

  public function payments(): PaymentCollection {
    $paymentsLink = $this->links->payments;
    if($paymentsLink === null) {
      return new PaymentCollection($this->client, 0, new Links());
    } else {
      $result = $this->client->performHttpCallToFullUrl(
        MollieApiClient::HTTP_GET,
        $paymentsLink->href
      );

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['payments'] ?? vec[],
        Payment::class,
        $result->links
      );
    }
  }

  <<__Override>>
  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->customerId = (string)$datas['customerId'];
    $this->mode = (string)$datas['mode'];
    $this->createdAt = (string)$datas['createdAt'];

    $this->status = SubscriptionStatus::assert((string)$datas['status']);

    $this->amount = to_dict($datas['amount']) |> Amount::parse($$);

    if(C\contains_key($datas, 'times') && $datas['times'] !== null) {
      $this->times = (int)$datas['times'];
    }

    $this->interval = (string)$datas['interval'];
    $this->description = (string)$datas['description'];

    if(C\contains_key($datas, 'method') && $datas['method'] !== null) {
      $this->method = (string)$datas['method'];
    }

    if(C\contains_key($datas, 'mandateId') && $datas['mandateId'] !== null) {
      $this->mandateId = (string)$datas['mandateId'];
    }

    $this->metadata = $datas['metadata'];

    if(C\contains_key($datas, 'canceledAt') && $datas['canceledAt'] !== null) {
      $this->canceledAt = (string)$datas['canceledAt'];
    }

    if(C\contains_key($datas, 'startDate') && $datas['startDate'] !== null) {
      $this->startDate = (string)$datas['startDate'];
    }

    if(C\contains_key($datas, 'webhookUrl') && $datas['webhookUrl'] !== null) {
      $this->webhookUrl = (string)$datas['webhookUrl'];
    }

    if(C\contains_key($datas, 'nextPaymentDate') && $datas['nextPaymentDate'] !== null) {
      $this->nextPaymentDate = (string)$datas['nextPaymentDate'];
    }

    $this->links = to_dict($datas['_links']) |> Links::parse($$);
  }
}
