namespace Mollie\Api\Resources;

class MethodCollection extends BaseCollectionBridge<Method> {
  public function getCollectionResourceName(): string {
    return 'methods';
  }
}
