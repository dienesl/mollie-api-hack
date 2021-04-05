namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Dict
};
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\{
  PaymentStatus,
  SequenceType
};
use function Mollie\Api\Functions\{
  to_dict,
  to_dict_with_vec_dict,
  to_vec_dict,
};
use function json_encode;
use function urlencode;

class Payment extends BaseResource {
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the payment(on the Mollie platform).
   */
  <<__LateInit>>
  public string $id;

  /**
   * Mode of the payment, either "live" or "test" depending on the API Key that was
   * used.
   */
  <<__LateInit>>
  public string $mode;

  /**
   * Amount object containing the value and currency
   */
  <<__LateInit>>
  public Amount $amount;

  /**
   * The amount that has been settled containing the value and currency
   */
  public ?Amount $settlementAmount;

  /**
   * The amount of the payment that has been refunded to the consumer, in EURO with
   * 2 decimals. This field will be null if the payment can not be refunded.
   */
  public ?Amount $amountRefunded;

  /**
   * The amount of a refunded payment that can still be refunded, in EURO with 2
   * decimals. This field will be null if the payment can not be refunded.
   *
   * For some payment methods this amount can be higher than the payment amount.
   * This is possible to reimburse the costs for a return shipment to your customer
   * for example.
   */
  public ?Amount $amountRemaining;

  /**
   * The total amount that was charged back for this payment. Only available when the
   * total charged back amount is not zero.
   */
  public ?Amount $amountChargedBack;

  /**
   * Description of the payment that is shown to the customer during the payment,
   * and possibly on the bank or credit card statement.
   */
  <<__LateInit>>
  public string $description;

  /**
   * If method is empty/null, the customer can pick his/her preferred payment
   * method.
   *
   * @see Method
   */
  public ?string $method;

  /**
   * The status of the payment.
   */
  public PaymentStatus $status = PaymentStatus::STATUS_OPEN;

  /**
   * UTC datetime the payment was created in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $createdAt;

  /**
   * UTC datetime the payment was paid in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $paidAt;

  /**
   * UTC datetime the payment was canceled in ISO-8601 format.
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $canceledAt;

  /**
   * UTC datetime the payment expired in ISO-8601 format.
   */
  public ?string $expiresAt;

  /**
   * UTC datetime the payment failed in ISO-8601 format.
   */
  public ?string $failedAt;

  /**
   * $dueDate is used only for banktransfer method
   * The date the payment should expire. Please note: the minimum date is tomorrow and the maximum date is 100 days after tomorrow.
   * UTC due date for the banktransfer payment in ISO-8601 format.
   *
   * @example "2021-01-19"
   */
  public ?string $dueDate;

  /**
   * Consumer’s email address, to automatically send the bank transfer details to.
   * Please note: the payment instructions will be sent immediately when creating the payment.
   *
   * @example "user@mollie.com"
   */
  public ?string $billingEmail;

  /**
   * The profile ID this payment belongs to.
   *
   * @example pfl_xH2kP6Nc6X
   */
  <<__LateInit>>
  public string $profileId;

  /**
   * Either "first", "recurring", or "oneoff" for regular payments.
   */
  public ?string $sequenceType;

  /**
   * Redirect URL set on this payment
   */
  <<__LateInit>>
  public string $redirectUrl;

  /**
   * Webhook URL set on this payment
   */
  public ?string $webhookUrl;

  /**
   * The mandate ID this payment is performed with.
   *
   * @example mdt_pXm1g3ND
   */
  public ?string $mandateId;

  /**
   * The subscription ID this payment belongs to.
   *
   * @example sub_rVKGtNd6s3
   */
  public ?string $subscriptionId;

  /**
   * The order ID this payment belongs to.
   *
   * @example ord_pbjz8x
   */
  public ?string $orderId;

  /**
   * The settlement ID this payment belongs to.
   *
   * @example stl_jDk30akdN
   */
  public ?string $settlementId;

  /**
   * The locale used for this payment.
   */
  public ?string $locale;

  /**
   * During creation of the payment you can set custom metadata that is stored with
   * the payment, and given back whenever you retrieve that payment.
   *
   * @var \stdClass|mixed|null
   * TODO, what is this?
   */
  public mixed $metadata;

  /**
   * Details of a successfully paid payment are set here. For example, the iDEAL
   * payment method will set $details->consumerName and $details->consumerAccount.
   * TODO https://docs.mollie.com/reference/v2/payments-api/get-payment
   */
  <<__LateInit>>
  public Details $details;

  /**
   * Used to restrict the payment methods available to your customer to those from a single country.
   */
  public ?string $restrictPaymentMethodsToCountry;

  <<__LateInit>>
  public Links $links;

  <<__LateInit>>
  public dict<string, vec<dict<string, mixed>>> $embedded;

  /**
   * Whether or not this payment can be canceled.
   */
  public ?bool $isCancelable;

  /**
   * The total amount that is already captured for this payment. Only available
   * when this payment supports captures.
   */
  public ?Amount $amountCaptured;

  /**
   * The application fee, if the payment was created with one. Contains amount
   *(the value and currency) and description.
   */
  public ?ApplicationFee $applicationFee;

  /**
   * The date and time the payment became authorized, in ISO 8601 format. This
   * parameter is omitted if the payment is not authorized(yet).
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $authorizedAt;

  /**
   * The date and time the payment was expired, in ISO 8601 format. This
   * parameter is omitted if the payment did not expire(yet).
   *
   * @example "2013-12-25T10:30:54+00:00"
   */
  public ?string $expiredAt;

  /**
   * If a customer was specified upon payment creation, the customer’s token will
   * be available here as well.
   *
   * @example cst_XPn78q9CfT
   */
  public ?string $customerId;

  /**
   * This optional field contains your customer’s ISO 3166-1 alpha-2 country code,
   * detected by us during checkout. For example: BE. This field is omitted if the
   * country code was not detected.
   */
  public ?string $countryCode;

  /**
   * Is this payment canceled?
   */
  public function isCanceled(): bool {
  return $this->status === PaymentStatus::STATUS_CANCELED;
  }

  /**
   * Is this payment expired?
   */
  public function isExpired(): bool {
  return $this->status === PaymentStatus::STATUS_EXPIRED;
  }

  /**
   * Is this payment still open / ongoing?
   */
  public function isOpen(): bool {
  return $this->status === PaymentStatus::STATUS_OPEN;
  }

  /**
   * Is this payment pending?
   */
  public function isPending(): bool {
  return $this->status === PaymentStatus::STATUS_PENDING;
  }

  /**
   * Is this payment authorized?
   */
  public function isAuthorized(): bool {
  return $this->status === PaymentStatus::STATUS_AUTHORIZED;
  }

  /**
   * Is this payment paid for?
   */
  public function isPaid(): bool {
  return $this->paidAt !== null;
  }

  /**
   * Does the payment have refunds
   */
  public function hasRefunds(): bool {
  return $this->links->refunds !== null;
  }

  /**
   * Does this payment has chargebacks
   *
   * @return bool
   */
  public function hasChargebacks(): bool {
  return $this->links->chargebacks !== null;
  }

  /**
   * Is this payment failing?
   */
  public function isFailed(): bool {
  return $this->status === PaymentStatus::STATUS_FAILED;
  }

  /**
   * Check whether 'sequenceType' is set to 'first'. If a 'first' payment has been
   * completed successfully, the consumer's account may be charged automatically
   * using recurring payments.
   */
  public function hasSequenceTypeFirst(): bool {
  return $this->sequenceType === SequenceType::SEQUENCETYPE_FIRST;
  }

  /**
   * Check whether 'sequenceType' is set to 'recurring'. This type of payment is
   * processed without involving
   * the consumer.
   */
  public function hasSequenceTypeRecurring(): bool {
  return $this->sequenceType === SequenceType::SEQUENCETYPE_RECURRING;
  }

  /**
   * Get the checkout URL where the customer can complete the payment.
   */
  public function getCheckoutUrl(): ?string {
  return $this->links->checkout?->href;
  }

  public function canBeRefunded(): bool {
  return $this->amountRemaining !== null;
  }

  public function canBePartiallyRefunded(): bool {
  return $this->canBeRefunded();
  }

  /**
   * Get the amount that is already refunded
   */
  public function getAmountRefunded(): float {
  if($this->amountRefunded !== null) {
    return $this->amountRefunded->value;
  }

  return .0;
  }

  /**
   * Get the remaining amount that can be refunded. For some payment methods this
   * amount can be higher than the payment amount. This is possible to reimburse
   * the costs for a return shipment to your customer for example.
   *
   * @return float
   */
  public function getAmountRemaining(): float {
  if($this->amountRemaining !== null) {
    return $this->amountRemaining->value;
  }

  return .0;
  }

  /**
   * Retrieves all refunds associated with this payment
   */
  public function refunds(): RefundCollection {
  $refundsLink = $this->links->refunds;
  if($refundsLink === null) {
    return new RefundCollection($this->client, 0, new Links());
  } else {
    $result = $this->client->performHttpCallToFullUrl(
    MollieApiClient::HTTP_GET,
    $refundsLink->href
    );

    return ResourceFactory::createCursorResourceCollection(
    $this->client,
    Refund::class,
    RefundCollection::class,
    to_vec_dict($result['_embedded']['refunds'] ?? vec[]),
    to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
    );
  }
  }

  public function getRefund(
  string $refundId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Refund {
  return $this->client->paymentRefunds->getFor($this, $refundId, $this->withPresetOptions($parameters));
  }

  public function listRefunds(
  dict<arraykey, mixed> $parameters = dict[]
  ): Refund {
  return $this->client->paymentRefunds->listFor($this, $this->withPresetOptions($parameters));
  }

  /**
   * Retrieves all captures associated with this payment
   */
  public function captures(): CaptureCollection {
  $capturesLink = $this->links->captures;
  if($capturesLink === null) {
    return new CaptureCollection($this->client, 0, new Links());
  } else {
    $result = $this->client->performHttpCallToFullUrl(
    MollieApiClient::HTTP_GET,
    $capturesLink->href
    );

    return ResourceFactory::createCursorResourceCollection(
    $this->client,
    Capture::class,
    CaptureCollection::class,
    to_vec_dict($result['_embedded']['captures'] ?? vec[]),
    to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
    );
  }
  }

  public function getCapture(
  string $captureId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Capture {
  return $this->client->paymentCaptures->getFor(
    $this,
    $captureId,
    $this->withPresetOptions($parameters)
  );
  }

  /**
   * Retrieves all chargebacks associated with this payment
   */
  public function chargebacks(): ChargebackCollection {
  $chargebacksLink = $this->links->chargebacks;
  if($chargebacksLink === null) {
    return new ChargebackCollection($this->client, 0, new Links());
  } else {
    $result = $this->client->performHttpCallToFullUrl(
    MollieApiClient::HTTP_GET,
    $chargebacksLink->href
    );

    return ResourceFactory::createCursorResourceCollection(
    $this->client,
    Chargeback::class,
    ChargebackCollection::class,
    to_vec_dict($result['_embedded']['chargebacks'] ?? vec[]),
    to_dict($result['_links'] ?? dict[]) |> Links::assert($$)
    );
  }
  }

  /**
   * Retrieves a specific chargeback for this payment.
   */
  public function getChargeback(
  string $chargebackId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Chargeback {
  return $this->client->paymentChargebacks->getFor(
    $this,
    $chargebackId,
    $this->withPresetOptions($parameters)
  );
  }

  /**
   * Issue a refund for this payment.
   */
  public function refund(
  dict<arraykey, mixed> $data
  ): Refund {
  $resource = 'payments/' . urlencode($this->id) . '/refunds';

  $data = $this->withPresetOptions($data);
  $body = null;
  if(C\count($data) > 0) {
    $body = json_encode($data);
  }

  $result = $this->client->performHttpCall(
    MollieApiClient::HTTP_POST,
    $resource,
    $body
  );

  return ResourceFactory::createFromApiResult(
    $result,
    new Refund($this->client)
  );
  }

  public function update(): Payment {
  $selfLink = $this->links->self;
  if($selfLink === null) {
    return $this;
  } else {
    $body = json_encode(dict[
    'description' => $this->description,
    'redirectUrl' => $this->redirectUrl,
    'webhookUrl' => $this->webhookUrl,
    'metadata' => $this->metadata,
    'restrictPaymentMethodsToCountry' => $this->restrictPaymentMethodsToCountry,
    ]);

    $result = $this->client->performHttpCallToFullUrl(
    MollieApiClient::HTTP_PATCH,
    $selfLink->href,
    $body
    );

    return ResourceFactory::createFromApiResult(
    $result,
    new Payment($this->client)
    );
  }
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

  /**
   * The total amount that is already captured for this payment. Only available
   * when this payment supports captures.
   */
  public function getAmountCaptured(): float {
  if($this->amountCaptured !== null) {
    return $this->amountCaptured->value;
  }

  return .0;
  }

  /**
   * The amount that has been settled.
   */
  public function getSettlementAmount(): float {
  if($this->settlementAmount !== null) {
    return $this->settlementAmount->value;
  }

  return .0;
  }

  /**
   * The total amount that is already captured for this payment. Only available
   * when this payment supports captures.
   */
  public function getApplicationFeeAmount(): float {
  if($this->applicationFee !== null) {
    return $this->applicationFee->amount->value;
  }

  return .0;
  }

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->resource = (string)$datas['resource'];
  $this->id = (string)$datas['id'];
  $this->mode = (string)$datas['mode'];

  $this->amount = to_dict($datas['amount']) |> Amount::assert($$);

  if(C\contains_key($datas, 'settlementAmount') && $datas['settlementAmount'] !== null) {
    $this->settlementAmount = to_dict($datas['settlementAmount']) |> Amount::assert($$);
  }

  if(C\contains_key($datas, 'amountRefunded') && $datas['amountRefunded'] !== null) {
    $this->amountRefunded = to_dict($datas['amountRefunded']) |> Amount::assert($$);
  }

  if(C\contains_key($datas, 'amountRemaining') && $datas['amountRemaining'] !== null) {
    $this->amountRemaining = to_dict($datas['amountRemaining']) |> Amount::assert($$);
  }

  if(C\contains_key($datas, 'amountChargedBack') && $datas['amountChargedBack'] !== null) {
    $this->amountRemaining = to_dict($datas['amountChargedBack']) |> Amount::assert($$);
  }

  $this->description = (string)$datas['description'];

  if(C\contains_key($datas, 'method') && $datas['method'] !== null) {
    $this->method = (string)$datas['method'];
  }

  if(C\contains_key($datas, 'status') && $datas['status'] !== null) {
    $this->status = PaymentStatus::assert($datas['status']);
  }

  if(C\contains_key($datas, 'createdAt') && $datas['createdAt'] !== null) {
    $this->createdAt = (string)$datas['createdAt'];
  }

  if(C\contains_key($datas, 'paidAt') && $datas['paidAt'] !== null) {
    $this->paidAt = (string)$datas['paidAt'];
  }

  if(C\contains_key($datas, 'canceledAt') && $datas['canceledAt'] !== null) {
    $this->canceledAt = (string)$datas['canceledAt'];
  }

  if(C\contains_key($datas, 'expiresAt') && $datas['expiresAt'] !== null) {
    $this->expiresAt = (string)$datas['expiresAt'];
  }

  if(C\contains_key($datas, 'failedAt') && $datas['failedAt'] !== null) {
    $this->failedAt = (string)$datas['failedAt'];
  }

  if(C\contains_key($datas, 'dueDate') && $datas['dueDate'] !== null) {
    $this->dueDate = (string)$datas['dueDate'];
  }

  if(C\contains_key($datas, 'billingEmail') && $datas['billingEmail'] !== null) {
    $this->billingEmail = (string)$datas['billingEmail'];
  }

  $this->profileId = (string)$datas['profileId'];

  if(C\contains_key($datas, 'sequenceType') && $datas['sequenceType'] !== null) {
    $this->sequenceType = (string)$datas['sequenceType'];
  }

  $this->redirectUrl = (string)$datas['redirectUrl'];

  if(C\contains_key($datas, 'webhookUrl') && $datas['webhookUrl'] !== null) {
    $this->webhookUrl = (string)$datas['webhookUrl'];
  }

  if(C\contains_key($datas, 'mandateId') && $datas['mandateId'] !== null) {
    $this->mandateId = (string)$datas['mandateId'];
  }

  if(C\contains_key($datas, 'subscriptionId') && $datas['subscriptionId'] !== null) {
    $this->subscriptionId = (string)$datas['subscriptionId'];
  }

  if(C\contains_key($datas, 'orderId') && $datas['orderId'] !== null) {
    $this->orderId = (string)$datas['orderId'];
  }

  if(C\contains_key($datas, 'settlementId') && $datas['settlementId'] !== null) {
    $this->settlementId = (string)$datas['settlementId'];
  }

  if(C\contains_key($datas, 'locale') && $datas['locale'] !== null) {
    $this->locale = (string)$datas['locale'];
  }

  $this->metadata = $datas['metadata'];

  $this->details = to_dict($datas['details']) |> Details::assert($$);

  if(C\contains_key($datas, 'restrictPaymentMethodsToCountry') && $datas['restrictPaymentMethodsToCountry'] !== null) {
    $this->restrictPaymentMethodsToCountry = (string)$datas['restrictPaymentMethodsToCountry'];
  }

  $this->links = to_dict($datas['_links'] ?? dict[]) |> Links::assert($$);

  $this->embedded = to_dict_with_vec_dict($datas['_embedded'] ?? vec[]);

  $this->isCancelable = (bool)$datas['isCancelable'];

  if(C\contains_key($datas, 'amountCaptured') && $datas['amountCaptured'] !== null) {
    $this->amountCaptured = to_dict($datas['amountCaptured']) |> Amount::assert($$);
  }

  if(C\contains_key($datas, 'applicationFee') && $datas['applicationFee'] !== null) {
    $this->applicationFee = to_dict($datas['applicationFee']) |> ApplicationFee::assert($$);
  }

  if(C\contains_key($datas, 'authorizedAt') && $datas['authorizedAt'] !== null) {
    $this->authorizedAt = (string)$datas['authorizedAt'];
  }

  if(C\contains_key($datas, 'expiredAt') && $datas['expiredAt'] !== null) {
    $this->expiredAt = (string)$datas['expiredAt'];
  }

  if(C\contains_key($datas, 'customerId') && $datas['customerId'] !== null) {
    $this->customerId = (string)$datas['customerId'];
  }

  if(C\contains_key($datas, 'countryCode') && $datas['countryCode'] !== null) {
    $this->countryCode = (string)$datas['countryCode'];
  }
  }
}
