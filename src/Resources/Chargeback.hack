namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Str
};
use type Mollie\Api\Exceptions\ApiException;
use function Mollie\Api\Functions\to_dict;

class Chargeback extends BaseResource {
  /**
   * Id of the payment method.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The $amount that was refunded.
   */
  <<__LateInit>>
  public Amount $amount;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   */
  <<__LateInit>>
  public ?string $createdAt;

  /**
   * The payment id that was refunded.
   */
  <<__LateInit>>
  public string $paymentId;

  /**
   * The settlement amount
   */
  <<__LateInit>>
  public Amount $settlementAmount;

  <<__LateInit>>
  public Links $links;

  <<__Override>>
  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->id = (string)$datas['id'];

    $this->amount = to_dict($datas['amount']) |> Amount::parse($$);

    if(C\contains_key($datas, 'createdAt')) {
      $createdAt = (string)$datas['createdAt'];
      if(!Str\is_empty($createdAt)) {
        $this->createdAt = $createdAt;
      }
    }
    
    $this->paymentId = (string)$datas['paymentId'];

    $this->settlementAmount = to_dict($datas['settlementAmount']) |> Amount::parse($$);

    $this->links = to_dict($datas['_links']) |> Links::parse($$);
  }
}
