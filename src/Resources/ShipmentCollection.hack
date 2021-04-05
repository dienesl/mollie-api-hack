namespace Mollie\Api\Resources;

class ShipmentCollection extends BaseCollectionBridge<Shipment> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'shipments';
  }
}
