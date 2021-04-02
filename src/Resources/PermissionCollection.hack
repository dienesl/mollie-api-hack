namespace Mollie\Api\Resources;

class PermissionCollection extends BaseCollection {
  public function getCollectionResourceName(): string {
    return 'permissions';
  }
}
