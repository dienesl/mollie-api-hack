namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\MollieApiClient;
use function Mollie\Api\Functions\{
  to_dict,
  to_vec_dict
};
use function json_encode;

class Shipment extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * The shipment’s unique identifier,
   *
   * @example shp_3wmsgCJN4U
   */
  <<__LateInit>>
  public string $id;

  /**
   * Id of the order.
   *
   * @example ord_8wmqcHMN4U
   */
  <<__LateInit>>
  public string $orderId;

  /**
   * UTC datetime the shipment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $createdAt;

  /**
   * The order object lines contain the actual things the customer bought.
   */
  public mixed $lines;

  /**
   * An object containing tracking details for the shipment, if available.
   */
  public ?Tracking $tracking;

  /**
   * An object with several URL objects relevant to the customer. Every URL object will contain an href and a type field.
   */
  <<__LateInit>>
  public Links $links;

  /**
   * Does this shipment offer track and trace?
   */
  public function hasTracking(): bool {
  return $this->tracking !== null;
  }

  /**
   * Does this shipment offer a track and trace code?
   */
  public function hasTrackingUrl(): bool {
  return $this->tracking !== null && $this->tracking->url !== null;
  }

  /**
   * Retrieve the track and trace url. Returns null if there is no url available.
   */
  public function getTrackingUrl(): ?string {
  return $this->tracking?->url;
  }

  /**
   * Get the line value objects
   */
  public function lines(): OrderLineCollection {
  return ResourceFactory::createBaseResourceCollection(
    $this->client,
    OrderLine::class,
    OrderLineCollection::class,
    to_vec_dict($this->lines),
    new Links()
  );
  }

  /**
   * Get the Order object for this shipment
   */
  public function order(): Order {
  return $this->client->orders->get($this->orderId);
  }

  /**
   * Save changes made to this shipment.
   */
  public function update(): Shipment {
  $selfLink = $this->links->self;
  if($selfLink === null) {
    return $this;
  } else {
    $body = json_encode(dict[
    'tracking' => $this->tracking,
    ]);

    $result = $this->client->performHttpCallToFullUrl(
    MollieApiClient::HTTP_PATCH,
    $selfLink->href,
    $body
    );

    return ResourceFactory::createFromApiResult(
    $result,
    new Shipment($this->client)
    );
  }
  }

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->resource = (string)$datas['resource'];
  $this->id = (string)$datas['id'];
  $this->orderId = (string)$datas['orderId'];

  if(C\contains_key($datas, 'createdAt') && $datas['createdAt'] !== null) {
    $this->createdAt = (string)$datas['createdAt'];
  }

  $this->lines = $datas['lines'];

  if(C\contains_key($datas, 'tracking') && $datas['tracking'] !== null) {
    $this->tracking = to_dict($datas['tracking']) |> Tracking::assert($$);
  }

  $this->links = to_dict($datas['links']) |> Links::assert($$);
  }
}
