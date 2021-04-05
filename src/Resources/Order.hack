namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Dict
};
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\OrderStatus;
use function Mollie\Api\Functions\{
  to_dict,
  to_dict_with_vec_dict,
  to_vec_dict,
};
use function json_encode;

class Order extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the order.
   *
   * @example ord_8wmqcHMN4U
   */
  <<__LateInit>>
  public string $id;

  /**
   * The profile ID this order belongs to.
   *
   * @example pfl_xH2kP6Nc6X
   */
  <<__LateInit>>
  public string $profileId;

  /**
   * Either "live" or "test". Indicates this being a test or a live(verified) order.
   */
  <<__LateInit>>
  public string $mode;

  /**
   * Amount object containing the value and currency
   */
  <<__LateInit>>
  public Amount $amount;

  /**
   * The total amount captured, thus far.
   */
  <<__LateInit>>
  public Amount $amountCaptured;

  /**
   * The total amount refunded, thus far.
   */
  <<__LateInit>>
  public Amount $amountRefunded;

  /**
   * The status of the order.
   */
  <<__LateInit>>
  public OrderStatus $status;

  /**
   * The person and the address the order is billed to.
   */
  <<__LateInit>>
  public Address $billingAddress;

  /**
   * The date of birth of your customer, if available.
   * @example 1976-08-21
   */
  public ?string $consumerDateOfBirth;

  /**
   * The order number that was used when creating the order.
   */
  <<__LateInit>>
  public string $orderNumber;

  /**
   * The person and the address the order is billed to.
   */
  <<__LateInit>>
  public Address $shippingAddress;

  /**
   * The payment method last used when paying for the order.
   *
   * @see Method
   */
  public ?string $method;

  /**
   * The locale used for this order.
   */
  <<__LateInit>>
  public string $locale;

  /**
   * During creation of the order you can set custom metadata that is stored with
   * the order, and given back whenever you retrieve that order.
   *
   * @var \stdClass|mixed|null
   * TODO
   */
  public mixed $metadata;

  /**
   * Can this order be canceled?
   */
  <<__LateInit>>
  public bool $isCancelable;

  /**
   * Webhook URL set on this payment
   */
  public ?string $webhookUrl;

  /**
   * Redirect URL set on this payment
   */
  <<__LateInit>>
  public string $redirectUrl;

  /**
   * UTC datetime the order was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $createdAt;

  /**
   * UTC datetime the order the order will expire in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $expiresAt;

  /**
   * UTC datetime if the order is expired, the time of expiration will be present in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $expiredAt;

  /**
   * UTC datetime if the order has been paid, the time of payment will be present in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $paidAt;

  /**
   * UTC datetime if the order has been authorized, the time of authorization will be present in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $authorizedAt;

  /**
   * UTC datetime if the order has been canceled, the time of cancellation will be present in ISO 8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $canceledAt;

  /**
   * UTC datetime if the order is completed, the time of completion will be present in ISO 8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $completedAt;

  /**
   * The order lines contain the actual things the customer bought.
   */
  public mixed $lines;

  /**
   * An object with several URL objects relevant to the customer. Every URL object will contain an href and a type field.
   */
  <<__LateInit>>
  public Links $links;

  <<__LateInit>>
  public dict<string, vec<dict<string, mixed>>> $embedded;

  /**
   * Is this order created?
   */
  public function isCreated(): bool {
  return $this->status === OrderStatus::STATUS_CREATED;
  }

  /**
   * Is this order paid for?
   */
  public function isPaid(): bool {
  return $this->status === OrderStatus::STATUS_PAID;
  }

  /**
   * Is this order authorized?
   */
  public function isAuthorized(): bool {
  return $this->status === OrderStatus::STATUS_AUTHORIZED;
  }

  /**
   * Is this order canceled?
   *
   * @return bool
   */
  public function isCanceled(): bool {
  return $this->status === OrderStatus::STATUS_CANCELED;
  }

  /**
   *(Deprecated) Is this order refunded?
   * @deprecated 2018-11-27
   */
  <<__Deprecated('This function has been replaced at 2018-11-27', 10)>>
  public function isRefunded(): bool {
  return $this->status === OrderStatus::STATUS_REFUNDED;
  }

  /**
   * Is this order shipping?
   */
  public function isShipping(): bool {
  return $this->status === OrderStatus::STATUS_SHIPPING;
  }

  /**
   * Is this order completed?
   */
  public function isCompleted(): bool {
  return $this->status === OrderStatus::STATUS_COMPLETED;
  }

  /**
   * Is this order expired?
   */
  public function isExpired(): bool {
  return $this->status === OrderStatus::STATUS_EXPIRED;
  }

  /**
   * Is this order completed?
   */
  public function isPending(): bool {
  return $this->status === OrderStatus::STATUS_PENDING;
  }

  /**
   * Cancels this order.
   * If the order was partially shipped, the status will be "completed" instead of
   * "canceled".
   * Will throw a ApiException if the order id is invalid or the resource cannot
   * be found.
   */
  public function cancel(): Order {
  return $this->client->orders->cancel($this->id, $this->getPresetOptions());
  }

  /**
   * Cancel a line for this order.
   * The data array must contain a lines array.
   * You can pass an empty lines array if you want to cancel all eligible lines.
   * Returns null if successful.
   *
   * @param  array|null $data
   * @return null
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function cancelLines(
  dict<arraykey, mixed> $data
  ): void {
  $this->client->orderLines->cancelFor($this, $data);
  }

  /**
   * Cancels all eligible lines for this order.
   * Returns null if successful.
   *
   * @param  array|null $data
   * @return null
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function cancelAllLines(
  dict<arraykey, mixed> $data = dict[]
  ): void {
  $data['lines'] = dict[];

  $this->client->orderLines->cancelFor($this, $data);
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
   * Create a shipment for some order lines. You can provide an empty array for the
   * "lines" option to include all unshipped lines for this order.
   */
  public function createShipment(
  dict<arraykey, mixed> $options
  ): Shipment {
  return $this->client->shipments->createFor($this, $this->withPresetOptions($options));
  }

  /**
   * Create a shipment for all unshipped order lines.
   */
  public function shipAll(
  dict<arraykey, mixed> $options = dict[]
  ): Shipment {
  $options['lines'] = dict[];

  return $this->createShipment($options);
  }

  /**
   * Retrieve a specific shipment for this order.
   */
  public function getShipment(
  string $shipmentId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Shipment {
  return $this->client->shipments->getFor($this, $shipmentId, $this->withPresetOptions($parameters));
  }

  /**
   * Get all shipments for this order.
   */
  public function shipments(
  dict<arraykey, mixed> $parameters = dict[]
  ): ShipmentCollection {
  return $this->client->shipments->listFor($this, $this->withPresetOptions($parameters));
  }

  /**
   * Get the checkout URL where the customer can complete the payment.
   */
  public function getCheckoutUrl(): ?string {
  return $this->links->checkout?->href;
  }

  /**
   * Refund specific order lines.
   */
  public function refund(
  dict<arraykey, mixed> $data
  ): Refund {
  return $this->client->orderRefunds->createFor($this, $this->withPresetOptions($data));
  }

  /**
   * Refund all eligible order lines.
   */
  public function refundAll(
  dict<arraykey, mixed> $data = dict[]
  ): Refund {
  $data['lines'] = dict[];

  return $this->refund($data);
  }

  /**
   * Retrieves all refunds associated with this order
   */
  public function refunds(): RefundCollection {
  $refundsLink = $this->links->refunds;
  if($refundsLink === null) {
    return new RefundCollection($this->client, 0, new Links());
  } else {
    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $refundsLink->href);

    return ResourceFactory::createCursorResourceCollection(
    $this->client,
    Refund::class,
    RefundCollection::class,
    to_vec_dict($result->embedded['refunds'] ?? vec[]),
    $result->links
    );
  }
  }

  /**
   * Saves the order's updated billingAddress and/or shippingAddress.
   */
  public function update(): Order {
  $selfLink = $this->links->self;
  if($selfLink === null) {
    return $this;
  } else {
    $body = json_encode(dict[
    'billingAddress' => $this->billingAddress,
    'shippingAddress' => $this->shippingAddress,
    'orderNumber' => $this->orderNumber,
    'redirectUrl' => $this->redirectUrl,
    'webhookUrl' => $this->webhookUrl,
    ]);

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $selfLink->href, $body);

    return ResourceFactory::createFromApiResult($result, new Order($this->client));
  }
  }

  /**
   * Create a new payment for this Order.
   * TODO, what is $data here?
   */
  public function createPayment(
  mixed $data,
  dict<arraykey, mixed> $filters = dict[]
  ): Payment {
  return $this->client->orderPayments->createFor($this, $data, $filters);
  }

  /**
   * Retrieve the payments for this order.
   * Requires the order to be retrieved using the embed payments parameter.
   */
  public function payments(): ?PaymentCollection {
  if(!C\contains_key($this->embedded, 'payments')) {
    return null;
  }

  return ResourceFactory::createCursorResourceCollection(
    $this->client,
    Payment::class,
    PaymentCollection::class,
    $this->embedded['payments'] ?? vec[],
    new Links()
  );
  }

  /**
   * When accessed by oAuth we want to pass the testmode by default
   */
  private function getPresetOptions(): dict<arraykey, mixed> {
  $options = dict[];
  if($this->client->usesOAuth()) {
    $options['testmode'] = $this->mode === 'test' ? true : false;
  }

  return $options;
  }

  /**
   * Apply the preset options.
   */
  private function withPresetOptions(
  dict<arraykey, mixed> $options
  ): dict<arraykey, mixed> {
  return Dict\merge($this->getPresetOptions(), $options);
  }

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->resource = (string)$datas['resource'];
  $this->id = (string)$datas['id'];
  $this->profileId = (string)$datas['profileId'];
  $this->mode = (string)$datas['mode'];

  $this->amount = to_dict($datas['amount']) |> Amount::assert($$);
  $this->amountCaptured = to_dict($datas['amountCaptured']) |> Amount::assert($$);
  $this->amountRefunded = to_dict($datas['amountRefunded']) |> Amount::assert($$);

  $this->status = OrderStatus::assert((string)$datas['status']);

  $this->billingAddress = to_dict($datas['billingAddress']) |> Address::assert($$);

  if(C\contains_key($datas, 'consumerDateOfBirth')) {
    $this->consumerDateOfBirth = (string)$datas['consumerDateOfBirth'];
  }

  $this->orderNumber = (string)$datas['orderNumber'];

  $this->shippingAddress = to_dict($datas['shippingAddress']) |> Address::assert($$);

  if(C\contains_key($datas, 'method')) {
    $this->method = (string)$datas['method'];
  }

  $this->locale = (string)$datas['locale'];

  $this->metadata = $datas['metadata'];

  $this->isCancelable = (bool)$datas['isCancelable'];

  if(C\contains_key($datas, 'webhookUrl')) {
    $this->webhookUrl = (string)$datas['webhookUrl'];
  }

  $this->redirectUrl = (string)$datas['redirectUrl'];

  if(C\contains_key($datas, 'createdAt')) {
    $this->createdAt = (string)$datas['createdAt'];
  }

  if(C\contains_key($datas, 'expiresAt')) {
    $this->expiresAt = (string)$datas['expiresAt'];
  }

  if(C\contains_key($datas, 'expiredAt')) {
    $this->expiredAt = (string)$datas['expiredAt'];
  }

  if(C\contains_key($datas, 'paidAt')) {
    $this->paidAt = (string)$datas['paidAt'];
  }

  if(C\contains_key($datas, 'authorizedAt')) {
    $this->authorizedAt = (string)$datas['authorizedAt'];
  }

  if(C\contains_key($datas, 'canceledAt')) {
    $this->canceledAt = (string)$datas['canceledAt'];
  }

  $this->lines = $datas['lines'];

  $this->links = to_dict($datas['_links']) |> Links::assert($$);

  $this->embedded = to_dict_with_vec_dict($datas['_embedded']);
  }
}
