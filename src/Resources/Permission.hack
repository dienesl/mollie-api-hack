namespace Mollie\Api\Resources;

class Permission extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * @example payments.read
   */
  <<__LateInit>>
  public string $id;

  <<__LateInit>>
  public string $description;

  <<__LateInit>>
  public bool $granted;

  <<__LateInit>>
  public Links $links;
}
