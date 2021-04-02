namespace Mollie\Api\Resources;

class Organization extends BaseResource {
  /**
   * Id of the payment method.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The name of the organization.
   */
  <<__LateInit>>
  public string $name;

  /**
   * The email address of the organization.
   */
  <<__LateInit>>
  public string $email;

  /**
   * The preferred locale of the merchant which has been set in Mollie Dashboard.
   */
  <<__LateInit>>
  public string $locale;

  /**
   * The address of the organization.
   *
   * @var \stdClass
   * TODO
   */
  <<__LateInit>>
  public mixed $address;

  /**
   * The registration number of the organization at the(local) chamber of
   * commerce.
   */
  <<__LateInit>>
  public string $registrationNumber;

  /**
   * The VAT number of the organization, if based in the European Union. The VAT
   * number has been checked with the VIES by Mollie.
   */
  <<__LateInit>>
  public string $vatNumber;

  /**
   * The organization’s VAT regulation, if based in the European Union. Either "shifted"
   *(VAT is shifted) or dutch(Dutch VAT rate).
   */
  <<__LateInit>>
  public ?string $vatRegulation;

  <<__LateInit>>
  public Links $links;
}
