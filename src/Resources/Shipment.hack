namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use function json_encode;

class Shipment extends BaseResource {
  /**
   * @var string
   */
  public string $resource;

  /**
   * The shipment’s unique identifier,
   *
   * @example shp_3wmsgCJN4U
   * @var string
   */
  public string $id;

  /**
   * Id of the order.
   *
   * @example ord_8wmqcHMN4U
   * @var string
   */
  public string $orderId;

  /**
   * UTC datetime the shipment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   * @var string|null
   */
  public ?string $createdAt;

  /**
   * The order object lines contain the actual things the customer bought.
   * @var array|object[]
   */
  public dict<arraykey, mixed> $lines;

  /**
   * An object containing tracking details for the shipment, if available.
   * @var \stdClass|null
   * TODO
   */
  public mixed $tracking;

  /**
   * An object with several URL objects relevant to the customer. Every URL object will contain an href and a type field.
   */
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
    // TODO
    return $this->hasTracking() && ! empty($this->tracking->url);
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
      $this->lines
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
   *
   * @return BaseResource|Shipment
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function update(): Shipment {
    if($this->links->self === null) {
      return $this;
    }

    $body = json_encode(dict[
      'tracking' => $this->tracking,
    ]);

    $result = $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_PATCH,
      $this->links->self->href,
      $body
    );

    return ResourceFactory::createFromApiResult($result, new Shipment($this->client));
  }
}
