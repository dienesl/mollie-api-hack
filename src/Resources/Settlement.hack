namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Types\{
  HttpMethod,
  SettlementStatus
};
use function Mollie\Api\Functions\{
  to_dict,
  to_vec_dict
};

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
  public function paymentsAsync(
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<PaymentCollection> {
    return $this->client->settlementPayments->pageForIdAsync($this->id, null, $limit, $parameters);
  }

  /**
   * Retrieves all refunds associated with this settlement
   */
  public async function refundsAsync(): Awaitable<RefundCollection> {
    $refundsLink = $this->links->refunds;
    if($refundsLink === null) {
      return new RefundCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $refundsLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['refunds'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Refund::class,
        RefundCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
      );
    }
  }

  /**
   * Retrieves all chargebacks associated with this settlement
   */
  public async function chargebacksAsync(): Awaitable<ChargebackCollection> {
    $chargebacksLink = $this->links->chargebacks;
    if($chargebacksLink === null) {
      return new ChargebackCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $chargebacksLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['chargebacks'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Chargeback::class,
        ChargebackCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links']) |> Links::assert($$)
      );
    }
  }

  /**
   * Retrieves all captures associated with this settlement
   */
  public async function capturesAsync(): Awaitable<CaptureCollection> {
    $capturesLink = $this->links->captures;
    if($capturesLink === null) {
      return new CaptureCollection($this->client, 0, new Links());
    } else {
      $result = await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::GET,
        $capturesLink->href
      );

      $embedded = $result['_embedded'] ?? null;
      if($embedded is KeyedContainer<_, _>) {
        $targetEmbedded = $embedded['captures'] ?? null;
        if(!($targetEmbedded is Traversable<_>)) {
          $targetEmbedded = vec[];
        }
      } else {
        $targetEmbedded = vec[];
      }

      return ResourceFactory::createCursorResourceCollection(
        $this->client,
        Capture::class,
        CaptureCollection::class,
        to_vec_dict($targetEmbedded),
        to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
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
