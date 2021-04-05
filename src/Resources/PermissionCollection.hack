namespace Mollie\Api\Resources;

class PermissionCollection extends BaseCollectionBridge<Permission> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'permissions';
  }
}
