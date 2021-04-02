namespace Mollie\Api\Resources;

class Issuer extends BaseResource {
  /**
   * Id of the issuer.
   */
  <<__LateInit>>
  public string $id;

  /**
   * Name of the issuer.
   */
  <<__LateInit>>
  public string $name;

  /**
   * The payment method this issuer belongs to.
   *
   * @see Mollie_API_Object_Method
   */
  <<__LateInit>>
  public string $method;

  /**
   * Object containing a size1x or size2x image
   *
   * @var \stdClass
   * TODO
   */
  <<__LateInit>>
  public mixed $image;
}
