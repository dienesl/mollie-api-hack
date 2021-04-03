namespace Mollie\Api\Resources;

use namespace HH\Lib\Dict;
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\OrderStatus;
use function json_encode;

class Order extends BaseResource {
  public string $resource;

  /**
   * Id of the order.
   *
   * @example ord_8wmqcHMN4U
   */
  public string $id;

  /**
   * The profile ID this order belongs to.
   *
   * @example pfl_xH2kP6Nc6X
   */
  public string $profileId;

  /**
   * Either "live" or "test". Indicates this being a test or a live(verified) order.
   */
  public string $mode;

  /**
   * Amount object containing the value and currency
   *
   * @var \stdClass
   * TODO
   */
  public mixed $amount;

  /**
   * The total amount captured, thus far.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $amountCaptured;

  /**
   * The total amount refunded, thus far.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $amountRefunded;

  /**
   * The status of the order.
   */
  public OrderStatus $status;

  /**
   * The person and the address the order is billed to.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $billingAddress;

  /**
   * The date of birth of your customer, if available.
   * @example 1976-08-21
   */
  public ?string $consumerDateOfBirth;

  /**
   * The order number that was used when creating the order.
   */
  public string $orderNumber;

  /**
   * The person and the address the order is billed to.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $shippingAddress;

  /**
   * The payment method last used when paying for the order.
   *
   * @see Method
   */
  public string $method;

  /**
   * The locale used for this order.
   */
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
  public bool $isCancelable;

  /**
   * Webhook URL set on this payment
   */
  public ?string $webhookUrl;

  /**
   * Redirect URL set on this payment
   */
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
   *
   * @var array|object[]
   * TODO
   */
  public vec<mixed> $lines;

  /**
   * An object with several URL objects relevant to the customer. Every URL object will contain an href and a type field.
   */
  public Links $links;

  /**
   * @var \stdClass
   * TODO
   */
  public mixed $_embedded;

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
      $this->lines
    );
  }

  /**
   * Create a shipment for some order lines. You can provide an empty array for the
   * "lines" option to include all unshipped lines for this order.
   *
   * @param array $options
   */
  public function createShipment(
    dict<arraykey, mixed> $options
  ): Shipment {
    return $this->client->shipments->createFor($this, $this->withPresetOptions($options));
  }

  /**
   * Create a shipment for all unshipped order lines.
   *
   * @param array $options
   */
  public function shipAll(
    dict<arraykey, mixed> $options = dict[]
  ): Shipment {
    $options['lines'] = dict[];

    return $this->createShipment($options);
  }

  /**
   * Retrieve a specific shipment for this order.
   *
   * @param string $shipmentId
   * @param array $parameters
   */
  public function getShipment(
    string $shipmentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Shipment {
    return $this->client->shipments->getFor($this, $shipmentId, $this->withPresetOptions($parameters));
  }

  /**
   * Get all shipments for this order.
   *
   * @param array $parameters
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
   *
   * @param  array  $data
   */
  public function refund(
    dict<arraykey, mixed> $data
  ): Refund {
    return $this->client->orderRefunds->createFor($this, $this->withPresetOptions($data));
  }

  /**
   * Refund all eligible order lines.
   *
   * @param  array  $data
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
    if($this->links->refunds === null) {
      //return new RefundCollection($this->client, 0, null);
      return new RefundCollection($this->client, 0, new Links());
    }

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_GET, $this->links->refunds->href);

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $result->_embedded->refunds,
      Refund::class,
      $result->links
    );
  }

  /**
   * Saves the order's updated billingAddress and/or shippingAddress.
   *
   * @return \Mollie\Api\Resources\BaseResource|\Mollie\Api\Resources\Order
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function update(): BaseResource {
    if($this->links->self === null) {
      return $this;
    }

    $body = json_encode(dict[
      "billingAddress" => $this->billingAddress,
      "shippingAddress" => $this->shippingAddress,
      "orderNumber" => $this->orderNumber,
      "redirectUrl" => $this->redirectUrl,
      "webhookUrl" => $this->webhookUrl,
    ]);

    $result = $this->client->performHttpCallToFullUrl(MollieApiClient::HTTP_PATCH, $this->links->self->href, $body);

    return ResourceFactory::createFromApiResult($result, new Order($this->client));
  }

  /**
   * Create a new payment for this Order.
   *
   * @return \Mollie\Api\Resources\BaseResource|\Mollie\Api\Resources\Payment
   * TODO
   */
  public function createPayment(
    mixed $data,
    dict<arraykey, mixed> $filters = dict[]
  ): BaseResource {
    return $this->client->orderPayments->createFor($this, $data, $filters);
  }

  /**
   * Retrieve the payments for this order.
   * Requires the order to be retrieved using the embed payments parameter.
   *
   * @return null|\Mollie\Api\Resources\PaymentCollection
   * TODO
   */
  public function payments(): ?PaymentCollection {
    if(! isset($this->_embedded, $this->_embedded->payments)) {
      return null;
    }

    return ResourceFactory::createCursorResourceCollection(
      $this->client,
      $this->_embedded->payments,
      Payment::class
    );
  }

  /**
   * When accessed by oAuth we want to pass the testmode by default
   */
  private function getPresetOptions(): dict<arraykey, mixed> {
    $options = dict[];
    if($this->client->usesOAuth()) {
      $options["testmode"] = $this->mode === "test" ? true : false;
    }

    return $options;
  }

  /**
   * Apply the preset options.
   *
   * @param array $options
   * @return array
   */
  private function withPresetOptions(
    dict<arraykey, mixed> $options
  ): dict<arraykey, mixed> {
    return Dict\merge($this->getPresetOptions(), $options);
  }
}
