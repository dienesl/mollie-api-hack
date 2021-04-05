namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\SettlementStatus;
use function Mollie\Api\Functions\to_dict;

class Settlement extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the settlement.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The settlement reference. This corresponds to an invoice that's in your Dashboard.
   */
  <<__LateInit>>
  public string $reference;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   */
  <<__LateInit>>
  public string $createdAt;

  /**
   * The date on which the settlement was settled, in ISO 8601 format. When requesting the open settlement or next settlement the return value is null.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $settledAt;

  /**
   * Status of the settlement.
   */
  <<__LateInit>>
  public SettlementStatus $status;

  /**
   * Total settlement amount in euros.
   */
    <<__LateInit>>
  public Amount $amount;

  /**
   * Revenues and costs nested per year, per month, and per payment method.
   *
   * TODO
   * public dict<dict<<dict<vec<dict<string, mixed>>>> $periods;
   * https://docs.mollie.com/reference/v2/settlements-api/get-settlement#example
   */
  public mixed $periods;

  /**
   * The ID of the invoice on which this settlement is invoiced, if it has been invoiced.
   */
  public ?string $invoiceId;

  <<__LateInit>>
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
    $refundsLink = $this->links->refunds;
    if($refundsLink === null) {
      return new RefundCollection($this->client, 0, new Links());
    } else {
      // TODO MollieApiClient
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $refundsLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['refunds'] ?? vec[],
        Refund::class,
        $result->links
      );
    }
  }

  /**
   * Retrieves all chargebacks associated with this settlement
   */
  public function chargebacks(): ChargebackCollection {
    $chargebacksLink = $this->links->chargebacks;
    if($chargebacksLink === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    } else {
      // TODO MollieApiClient
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $chargebacksLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['chargebacks'] ?? vec[],
        Chargeback::class,
        $result->links
      );
    }
  }

  /**
   * Retrieves all captures associated with this settlement
   */
  public function captures(): CaptureCollection {
    $capturesLink = $this->links->captures;
    if($capturesLink === null) {
      return new CaptureCollection($this->client, 0, new Links());
    } else {
      // TODO MollieApiClient
      $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $capturesLink->href);

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        $result->embedded['captures'] ?? vec[],
        Capture::class,
        $result->links
      );
    }
  }

  <<__Override>>
  public function assert(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->reference = (string)$datas['reference'];
    $this->createdAt = (string)$datas['createdAt'];

    if(C\contains_key($datas, 'settledAt') && $datas['settledAt'] !== null) {
      $this->settledAt = (string)$datas['settledAt'];
    }

    $this->status = SettlementStatus::assert((string)$datas['status']);

    $this->amount = to_dict($datas['amount']) |> Amount::assert($$);

    $this->periods = $datas['periods'];

    if(C\contains_key($datas, 'invoiceId') && $datas['invoiceId'] !== null) {
      $this->invoiceId = (string)$datas['invoiceId'];
    }

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
