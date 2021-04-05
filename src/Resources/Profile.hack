namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\ProfileStatus;
use function Mollie\Api\Functions\to_dict;
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

  public function update(): Profile {
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

      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $selfLink->href, $body);

      return ResourceFactory::createFromApiResult($result, new Profile($this->client));
    }
  }

  /**
   * Retrieves all chargebacks associated with this profile
   */
  public function chargebacks(): ChargebackCollection {
    $chargebacksLink = $this->links->chargebacks;
    if($chargebacksLink === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    } else {
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $chargebacksLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['chargebacks'] ?? vec[],
        Chargeback::class,
        $result->links
      );
    }
  }

  /**
   * Retrieves all methods activated on this profile
   */
  public function methods(): MethodCollection {
    $methodsLink = $this->links->methods;
    if($methodsLink === null) {
      return new MethodCollection(0, new Links());
    } else {
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $methodsLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['methods'] ?? vec[],
        Method::class,
        $result->links
      );
    }
  }

  /**
   * Enable a payment method for this profile.
   */
  public function enableMethod(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Method {
    return $this->client->profileMethods->createFor($this, $methodId, $data);
  }

  /**
   * Disable a payment method for this profile.
   */
  public function disableMethod(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Method {
    return $this->client->profileMethods->deleteFor($this, $methodId, $data);
  }

  /**
   * Retrieves all payments associated with this profile
   */
  public function payments(): PaymentCollection {
    $paymentsLink = $this->links->payments;
    if($paymentsLink === null) {
      return new PaymentCollection($this->client, 0, new Links());
    } else {
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $paymentsLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['methods'] ?? vec[],
        Method::class,
        $result->links
      );
    }
  }

  public function refunds(): RefundCollection {
    $refundsLink = $this->links->refunds;
    if($refundsLink === null) {
      return new RefundCollection($this->client, 0, new Links());
    } else {
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $refundsLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['refunds'] ?? vec[],
        Refund::class,
        $result->links
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

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
