namespace Mollie\Api\Resources;

class ShipmentCollection extends BaseCollectionBridge<Shipment> {
  public function getCollectionResourceName(): string {
  return 'shipments';
  }
}
