namespace Mollie\Api\Resources;

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
  public dict<arraykey, mixed> $amount;

  /**
   * Amount object containing the settlement value and currency
   */
  <<__LateInit>>
  public dict<arraykey, mixed> $settlementAmount;

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
}
