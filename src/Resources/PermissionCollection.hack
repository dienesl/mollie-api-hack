namespace Mollie\Api\Resources;

class PermissionCollection extends BaseCollectionBridge<Permission> {
  public function getCollectionResourceName(): string {
    return 'permissions';
  }
}
