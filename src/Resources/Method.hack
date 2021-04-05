namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use function Mollie\Api\Functions\to_dict;

class Method extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the payment method.
   */
  <<__LateInit>>
  public string $id;

  /**
   * More legible description of the payment method.
   */
  <<__LateInit>>
  public string $description;

  /**
   * An object containing value and currency. It represents the minimum payment amount required to use this
   * payment method.
   */
  <<__LateInit>>
  public Amount $minimumAmount;

  /**
   * An object containing value and currency. It represents the maximum payment amount allowed when using this
   * payment method.
   */
  <<__LateInit>>
  public Amount $maximumAmount;

  /**
   * The $image->size1x and $image->size2x to display the payment method logo.
   */
  <<__LateInit>>
  public Image $image;

  /**
   * The issuers available for this payment method. Only for the methods iDEAL, KBC/CBC and gift cards.
   * Will only be filled when explicitly requested using the query string `include` parameter.
   * TODO
   */
  //public ?vec<Issuer> $issuers;
  public mixed $issuers;

  /**
   * The pricing for this payment method. Will only be filled when explicitly requested using the query string
   * `include` parameter.
   * TODO
   */
  //public vec<MethodPrice> $pricing = vec[];
  public mixed $pricing;

  /**
   * The activation status the method is in.
   */
  <<__LateInit>>
  public string $status;

  <<__LateInit>>
  public Links $links;

  /**
   * Get the issuer value objects
   * TODO
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
   * TODO
   */
  public function pricing(): MethodPriceCollection {
    return ResourceFactory::createBaseResourceCollection(
      $this->client,
      MethodPrice::class,
      $this->pricing
    );
  }

  <<__Override>>
  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->description = (string)$datas['description'];

    $this->minimumAmount = to_dict($datas['minimumAmount']) |> Amount::parse($$);
    $this->maximumAmount = to_dict($datas['maximumAmount']) |> Amount::parse($$);

    $this->image = to_dict($datas['image']) |> Image::parse($$);

    if(C\contains_key($datas, 'issuers')) {
      $this->issuers = $datas['issuers'];
    }

    if(C\contains_key($datas, 'pricing')) {
      $this->pricing = $datas['pricing'];
    }

    $this->status = (string)$datas['status'];

    $this->links = to_dict($datas['_links']) |> Links::parse($$);
  }
}
