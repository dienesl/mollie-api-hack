namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use function Mollie\Api\Functions\to_dict;

class Organization extends BaseResource {
  <<__LateInit>>
  public string $resource;

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
   */
  <<__LateInit>>
  public Address $address;

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
  public ?string $vatNumber;

  /**
   * The organization’s VAT regulation, if based in the European Union. Either "shifted"
   *(VAT is shifted) or dutch(Dutch VAT rate).
   */
  public ?string $vatRegulation;

  <<__LateInit>>
  public Links $links;

  <<__Override>>
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->name = (string)$datas['name'];
    $this->email = (string)$datas['email'];
    $this->locale = (string)$datas['locale'];

    $this->address = to_dict($datas['address']) |> Address::assert($$);

    $this->registrationNumber = (string)$datas['registrationNumber'];

    if(C\contains_key($datas, 'vatNumber') && $datas['vatNumber'] !== null) {
      $this->vatNumber = (string)$datas['vatNumber'];
    }

    if(C\contains_key($datas, 'vatRegulation') && $datas['vatRegulation'] !== null) {
      $this->vatRegulation = (string)$datas['vatRegulation'];
    }

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
