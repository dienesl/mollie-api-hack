namespace Mollie\Api\Resources;

use type Mollie\Api\Exceptions\ApiException;
use function Mollie\Api\Functions\to_dict;

class Capture extends BaseResource {
  /**
   * Always 'capture' for this object
   */
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the capture
   */
  <<__LateInit>>
  public string $id;

  /**
   * Mode of the capture, either "live" or "test" depending on the API Key that was used.
   */
  <<__LateInit>>
  public string $mode;

  /**
   * Amount object containing the value and currency
   */
  <<__LateInit>>
  public Amount $amount;

  /**
   * Amount object containing the settlement value and currency
   */
  <<__LateInit>>
  public Amount $settlementAmount;

  /**
   * Id of the capture's payment(on the Mollie platform).
   */
  <<__LateInit>>
  public string $paymentId;

  /**
   * Id of the capture's shipment(on the Mollie platform).
   */
  <<__LateInit>>
  public string $shipmentId;

  /**
   * Id of the capture's settlement(on the Mollie platform).
   */
  <<__LateInit>>
  public string $settlementId;

  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public Links $links;

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->resource = (string)$datas['resource'];
  $this->id = (string)$datas['id'];
  $this->mode = (string)$datas['mode'];

  $this->amount = to_dict($datas['amount']) |> Amount::assert($$);

  $this->settlementAmount = to_dict($datas['settlementAmount']) |> Amount::assert($$);

  $this->paymentId = (string)$datas['paymentId'];

  $this->shipmentId = (string)$datas['shipmentId'];

  $this->createdAt = (string)$datas['createdAt'];

  $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
