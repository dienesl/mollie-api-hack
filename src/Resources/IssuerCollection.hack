namespace Mollie\Api\Resources;

class IssuerCollection extends BaseCollectionBridge<Issuer> {
  public function getCollectionResourceName(): ?string {
    return null;
  }
}
