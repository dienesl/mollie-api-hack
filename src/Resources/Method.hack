namespace Mollie\Api\Resources;

class Method extends BaseResource {
  /**
   * Id of the payment method.
   */
  public string $id;

  /**
   * More legible description of the payment method.
   */
  public string $description;

  /**
   * An object containing value and currency. It represents the minimum payment amount required to use this
   * payment method.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $minimumAmount;

  /**
   * An object containing value and currency. It represents the maximum payment amount allowed when using this
   * payment method.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $maximumAmount;

  /**
   * The $image->size1x and $image->size2x to display the payment method logo.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $image;

  /**
   * The issuers available for this payment method. Only for the methods iDEAL, KBC/CBC and gift cards.
   * Will only be filled when explicitly requested using the query string `include` parameter.
   *
   * @var array|object[]
   * TODO
   */
  public vec<mixed> $issuers;

  /**
   * The pricing for this payment method. Will only be filled when explicitly requested using the query string
   * `include` parameter.
   *
   * @var array|object[]
   * TODO
   */
  public vec<mixed> $pricing;

  /**
   * The activation status the method is in.
   */
  public string $status;

  public Links $links;

  /**
   * Get the issuer value objects
   */
  public function issuers(): IssuerCollection {
    return ResourceFactory::createBaseResourceCollection(
      $this->client,
      Issuer::class,
      $this->issuers
    );
  }

  /**
   * Get the method price value objects.
   */
  public function pricing(): MethodPriceCollection {
    return ResourceFactory::createBaseResourceCollection(
      $this->client,
      MethodPrice::class,
      $this->pricing
    );
  }
}
