namespace Mollie\Api\Resources;

class MethodCollection extends BaseCollectionBridge<Method> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'methods';
  }
}
