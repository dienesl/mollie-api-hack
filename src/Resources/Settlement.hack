namespace Mollie\Api\Resources;

use Mollie\Api\Exceptions\ApiException;
use Mollie\Api\MollieApiClient;
use Mollie\Api\Types\SettlementStatus;

class Settlement extends BaseResource {
  /**
   * @var string
   */
  public string $resource;

  /**
   * Id of the settlement.
   *
   * @var string
   */
  public string $id;

  /**
   * The settlement reference. This corresponds to an invoice that's in your Dashboard.
   *
   * @var string
   */
  public string $reference;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   * @var string
   */
  public string $createdAt;

  /**
   * The date on which the settlement was settled, in ISO 8601 format. When requesting the open settlement or next settlement the return value is null.
   *
   * @example "2013-12-25T10:30:54+00:00"
   * @var string|null
   */
  public ?string $settledAt;

  /**
   * Status of the settlement.
   *
   * @var string
   */
  public string $status;

  /**
   * Total settlement amount in euros.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $amount;

  /**
   * Revenues and costs nested per year, per month, and per payment method.
   *
   * @var \stdClass
   */
  public $periods;

  /**
   * The ID of the invoice on which this settlement is invoiced, if it has been invoiced.
   *
   * @var string|null
   */
  public ?string $invoiceId;

  public Links $links;

  /**
   * Is this settlement still open?
   */
  public function isOpen(): bool {
    return $this->status === SettlementStatus::STATUS_OPEN;
  }

  /**
   * Is this settlement pending?
   */
  public function isPending(): bool {
    return $this->status === SettlementStatus::STATUS_PENDING;
  }

  /**
   * Is this settlement paidout?
   */
  public function isPaidout(): bool {
    return $this->status === SettlementStatus::STATUS_PAIDOUT;
  }

  /**
   * Is this settlement failed?
   */
  public function isFailed(): bool {
    return $this->status === SettlementStatus::STATUS_FAILED;
  }

  /**
   * Retrieves all payments associated with this settlement
   */
  public function payments(
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): PaymentCollection {
    return $this->client->settlementPayments->pageForId($this->id, null, $limit, $parameters);
  }

  /**
   * Retrieves all refunds associated with this settlement
   */
  public function refunds(): RefundCollection {
    if($this->links->refunds === null) {
      return new RefundCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->refunds->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['refunds'] ?? vec[],
      Refund::class,
      $result->links
    );
  }

  /**
   * Retrieves all chargebacks associated with this settlement
   */
  public function chargebacks(): ChargebackCollection {
    if($this->links->chargebacks === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->chargebacks->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['chargebacks'] ?? vec[],
      Chargeback::class,
      $result->links
    );
  }

  /**
   * Retrieves all captures associated with this settlement
   *
   * @return CaptureCollection
   * @throws ApiException
   */
  public function captures(): CaptureCollection {
    if($this->links->captures === null) {
      return new CaptureCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->captures->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->embedded['captures'] ?? vec[],
      Capture::class,
      $result->links
    );
  }
}
