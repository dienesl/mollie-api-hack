namespace Mollie\Api\Resources;

class VoidResourceCollection extends BaseCollection {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'voidResource';
  }
}
