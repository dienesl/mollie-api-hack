namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Types\{
  HttpMethod,
  ProfileStatus
};
use function Mollie\Api\Functions\{
  to_dict,
  to_vec_dict
};
use function json_encode;

class Profile extends BaseResource {
  <<__LateInit>>
  public string $resource;

  <<__LateInit>>
  public string $id;

  /**
   * Test or live mode
   */
  <<__LateInit>>
  public string $mode;

  <<__LateInit>>
  public string $name;

  <<__LateInit>>
  public string $website;

  <<__LateInit>>
  public string $email;

  <<__LateInit>>
  public string $phone;

  /**
   * See https://docs.mollie.com/reference/v2/profiles-api/get-profile
   */
  <<__LateInit>>
  public int $categoryCode;

  <<__LateInit>>
  public ProfileStatus $status;

  public ?Review $review;

  /**
   * UTC datetime the profile was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public Links $links;

  public function isUnverified(): bool {
    return $this->status === ProfileStatus::STATUS_UNVERIFIED;
  }

  public function isVerified(): bool {
    return $this->status === ProfileStatus::STATUS_VERIFIED;
  }

  public function isBlocked(): bool {
    return $this->status === ProfileStatus::STATUS_BLOCKED;
  }

  public async function updateAsync(): Awaitable<Profile> {
    $selfLink = $this->links->self;
    if($selfLink === null) {
      return $this;
    } else {
      $body = json_encode(dict[
        'name' => $this->name,
        'website' => $this->website,
        'email' => $this->email,
        'phone' => $this->phone,
        'categoryCode' => $this->categoryCode,
        'mode' => $this->mode,
      ]);

      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::PATCH,
        $selfLink->href,
        $body
      );

      return ResourceFactory::createFromApiResult(
        $result,
        new Profile($this->client)
      );
    }
  }

  /**
   * Retrieves all chargebacks associated with this profile
   */
  public async function chargebacksAsync(): Awaitable<ChargebackCollection> {
    $chargebacksLink = $this->links->chargebacks;
    if($chargebacksLink === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $chargebacksLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['chargebacks'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Chargeback::class,
        ChargebackCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );
    }
  }

  /**
   * Retrieves all methods activated on this profile
   */
  public async function methodsAsync(): Awaitable<MethodCollection> {
    $methodsLink = $this->links->methods;
    if($methodsLink === null) {
      return new MethodCollection(0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $methodsLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['methods'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      // probably it is wrong in the origin source
      //return ResourceFactory::createCursorResourceCollection(
      return ResourceFactory::createBaseResourceCollection(
        $this->client,
        Method::class,
        MethodCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );
    }
  }

  /**
   * Enable a payment method for this profile.
   */
  public function enableMethodAsync(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<Method> {
    return $this->client->profileMethods->createForAsync($this, $methodId, $data);
  }

  /**
   * Disable a payment method for this profile.
   */
  public function disableMethodAsync(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Method> {
    return $this->client->profileMethods->deleteForAsync($this, $methodId, $data);
  }

  /**
   * Retrieves all payments associated with this profile
   */
  public async function paymentsAsync(): Awaitable<PaymentCollection> {
    $paymentsLink = $this->links->payments;
    if($paymentsLink === null) {
      return new PaymentCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $paymentsLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['methods'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Payment::class,
        PaymentCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );
    }
  }

  public async function refundsAsync(): Awaitable<RefundCollection> {
    $refundsLink = $this->links->refunds;
    if($refundsLink === null) {
      return new RefundCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $refundsLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['refunds'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Refund::class,
        RefundCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );
    }
  }

  <<__Override>>
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->mode = (string)$datas['mode'];
    $this->name = (string)$datas['name'];
    $this->website = (string)$datas['website'];
    $this->email = (string)$datas['email'];
    $this->phone = (string)$datas['phone'];

    $this->categoryCode = (int)$datas['categoryCode'];

    $this->status = ProfileStatus::assert($datas['status']);

    if(C\contains($datas, 'review')) {
      $review = to_dict($datas['review']);
      $this->review = new Review((string)($review['status'] ?? ''));
    }

    $this->createdAt = (string)$datas['createdAt'];

    $this->links = to_dict($datas['_links'] ?? dict[]) |> Links::assert($$);
  }
}
