namespace Mollie\Api\Resources;

use namespace HH\Lib\{C};
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
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->id = (string)$datas['id'];

    $this->amount = to_dict($datas['amount']) |> Amount::assert($$);

    if(C\contains_key($datas, 'createdAt') && $datas['createdAt'] !== null) {
      $this->createdAt = (string)$datas['createdAt'];
    }

    $this->paymentId = (string)$datas['paymentId'];

    $this->settlementAmount = to_dict($datas['settlementAmount']) |> Amount::assert($$);

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
