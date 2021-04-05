namespace Mollie\Api\Resources;

class VoidResourceCollection extends BaseCollectionBridge<VoidResource> {
  <<__Override>>
  public function getCollectionResourceName(): ?string {
  return null;
  }
}
