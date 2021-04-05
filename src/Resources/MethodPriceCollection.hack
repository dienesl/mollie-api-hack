namespace Mollie\Api\Resources;

class MethodPriceCollection extends BaseCollectionBridge<MethodPrice> {
  <<__Override>>
  public function getCollectionResourceName(): ?string {
  return null;
  }
}
