namespace Mollie\Api\Resources;

use type Mollie\Api\Exceptions\ApiException;

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

  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->mode = (string)$datas['mode'];

    $amount = $datas['amount'];
    if($amount is KeyedContainer<_, _>) {
      $this->amount = new Amount(
        (float)$amount['value'],
        (string)$amount['currency']
      );
    } else {
      throw new ApiException('Missing amount in datas.');
    }

    $settlementAmount = $datas['settlementAmount'];
    if($settlementAmount is KeyedContainer<_, _>) {
      $this->settlementAmount = new Amount(
        (float)$settlementAmount['value'],
        (string)$settlementAmount['currency']
      );
    } else {
      throw new ApiException('Missing settlementAmount in datas.');
    }

    $this->paymentId = (string)$datas['paymentId'];

    $this->shipmentId = (string)$datas['shipmentId'];

    $this->createdAt = (string)$datas['createdAt'];
  }
}
