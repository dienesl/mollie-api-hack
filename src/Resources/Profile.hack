namespace Mollie\Api\Resources;

use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\ProfileStatus;
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
  public string $status;

  /**
   * @var \stdClass
   * TODO
   */
  <<__LateInit>>
  public mixed $review;

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
    return $this->status == ProfileStatus::STATUS_UNVERIFIED;
  }

  public function isVerified(): bool {
    return $this->status == ProfileStatus::STATUS_VERIFIED;
  }

  public function isBlocked(): bool {
    return $this->status == ProfileStatus::STATUS_BLOCKED;
  }

  public function update(): this {
    if($this->links->self === null) {
      return $this;
    }

    $body = json_encode(dict[
      'name' => $this->name,
      'website' => $this->website,
      'email' => $this->email,
      'phone' => $this->phone,
      'categoryCode' => $this->categoryCode,
      'mode' => $this->mode,
    ]);

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $this->links->self->href, $body);

    return ResourceFactory::createFromApiResult($result, new Profile($this->client));
  }

  /**
   * Retrieves all chargebacks associated with this profile
   */
  public function chargebacks(): ChargebackCollection {
    if($this->links->chargebacks === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->chargebacks->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['chargebacks'] ?? vec[],
      Chargeback::class,
      $result->links
    );
  }

  /**
   * Retrieves all methods activated on this profile
   */
  public function methods(): MethodCollection {
    if($this->links->methods === null) {
      return new MethodCollection(0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->methods->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['methods'] ?? vec[],
      Method::class,
      $result->links
    );
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
    if($this->links->payments === null) {
      return new PaymentCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->payments->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['methods'] ?? vec[],
      Method::class,
      $result->links
    );
  }

  /**
   * Retrieves all refunds associated with this profile
   *
   * @return RefundCollection
   * @throws ApiException
   */
  public function refunds(): RefundCollection {
    if($this->links->refunds === null) {
      return new RefundCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->refunds->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['refunds'] ?? vec[],
      Refund::class,
      $result->links
    );
  }
}
