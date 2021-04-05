namespace Mollie\Api\Resources;

use function Mollie\Api\Functions\to_dict;

class Issuer extends BaseResource {
  <<__LateInit>>
  public string $resource;

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

  <<__LateInit>>
  public Image $image;

  <<__Override>>
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->name = (string)$datas['name'];
    $this->method = (string)$datas['method'];

    $this->image = to_dict($datas['image']) |> Image::assert($$);
  }
}
