namespace Mollie\Api\Resources;

class ShipmentCollection extends BaseCollection {
  public function getCollectionResourceName(): string {
    return 'shipments';
  }
}
