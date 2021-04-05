namespace Mollie\Api\Resources;

class IssuerCollection extends BaseCollectionBridge<Issuer> {
  <<__Override>>
  public function getCollectionResourceName(): ?string {
  return null;
  }
}
