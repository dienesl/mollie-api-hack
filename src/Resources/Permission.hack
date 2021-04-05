namespace Mollie\Api\Resources;

use function Mollie\Api\Functions\to_dict;

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

  <<__Override>>
  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->description = (string)$datas['description'];

    $this->granted = (bool)$datas['granted'];

    $this->links = to_dict($datas['_links']) |> Links::parse($$);
  }
}
