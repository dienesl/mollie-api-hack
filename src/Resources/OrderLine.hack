namespace Mollie\Api\Resources;

use namespace HH\Lib\{
  C,
  Dict
};
use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\{
  OrderLineStatus,
  OrderLineType
};
use function Mollie\Api\Functions\to_dict;
use function json_encode;

class OrderLine extends BaseResource {
  /**
   * Always 'orderline'
   */
  <<__LateInit>>
  public string $resource;

  /**
   * Id of the order line.
   */
  <<__LateInit>>
  public string $id;

  /**
   * The ID of the order this line belongs to.
   *
   * @example ord_kEn1PlbGa
   */
  <<__LateInit>>
  public string $orderId;

  /**
   * The type of product bought.
   *
   * @example physical
   */
  <<__LateInit>>
  public OrderLineType $type;

  /**
   * A description of the order line.
   *
   * @example LEGO 4440 Forest Police Station
   */
  <<__LateInit>>
  public string $name;

  /**
   * The status of the order line.
   */
  <<__LateInit>>
  public OrderLineStatus $status;

  /**
   * Can this order line be canceled?
   */
  <<__LateInit>>
  public bool $isCancelable;

  /**
   * The number of items in the order line.
   */
  <<__LateInit>>
  public int $quantity;

  /**
   * The number of items that are shipped for this order line.
   */
  <<__LateInit>>
  public int $quantityShipped;

  /**
   * The total amount that is shipped for this order line.
   */
  <<__LateInit>>
  public Amount $amountShipped;

  /**
   * The number of items that are refunded for this order line.
   */
  <<__LateInit>>
  public int $quantityRefunded;

  /**
   * The total amount that is refunded for this order line.
   */
  <<__LateInit>>
  public Amount $amountRefunded;

  /**
   * The number of items that are canceled in this order line.
   */
  <<__LateInit>>
  public int $quantityCanceled;

  /**
   * The total amount that is canceled in this order line.
   */
  <<__LateInit>>
  public Amount $amountCanceled;

  /**
   * The number of items that can still be shipped for this order line.
   */
  <<__LateInit>>
  public int $shippableQuantity;

  /**
   * The number of items that can still be refunded for this order line.
   */
  <<__LateInit>>
  public int $refundableQuantity;

  /**
   * The number of items that can still be canceled for this order line.
   */
  <<__LateInit>>
  public int $cancelableQuantity;

  /**
   * The price of a single item in the order line.
   */
  <<__LateInit>>
  public Amount $unitPrice;

  /**
   * Any discounts applied to the order line.
   */
  public ?Amount $discountAmount;

  /**
   * The total amount of the line, including VAT and discounts.
   */
  <<__LateInit>>
  public Amount $totalAmount;

  /**
   * The VAT rate applied to the order line. It is defined as a string
   * and not as a float to ensure the correct number of decimals are
   * passed.
   *
   * @example "21.00"
   */
  <<__LateInit>>
  public float $vatRate;

  /**
   * The amount of value-added tax on the line.
   */
  <<__LateInit>>
  public Amount $vatAmount;

  /**
   * The SKU, EAN, ISBN or UPC of the product sold.
   */
  public ?string $sku;

  /**
   * A link pointing to an image of the product sold.
   */
  public ?string $imageUrl;

  /**
   * A link pointing to the product page in your web shop of the product sold.
   */
  public ?string $productUrl;
  
  /**
   * During creation of the order you can set custom metadata on order lines that is stored with
   * the order, and given back whenever you retrieve that order line.
   *
   * @var \stdClass|mixed|null
   * TODO
   */
  public mixed $metadata;

  /**
   * The order line's date and time of creation, in ISO 8601 format.
   *
   * @example 2018-08-02T09:29:56+00:00
   */
  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public Links $links;

  /**
   * Get the url pointing to the product page in your web shop of the product sold.
   */
  public function getProductUrl(): ?string {
    return $this->links->productUrl?->href;
  }

  /**
   * Get the image URL of the product sold.
   */
  public function getImageUrl(): ?string {
    return $this->links->imageUrl?->href;
  }

  /**
   * Is this order line created?
   */
  public function isCreated(): bool {
    return $this->status === OrderLineStatus::STATUS_CREATED;
  }

  /**
   * Is this order line paid for?
   */
  public function isPaid(): bool {
    return $this->status === OrderLineStatus::STATUS_PAID;
  }

  /**
   * Is this order line authorized?
   */
  public function isAuthorized(): bool {
    return $this->status === OrderLineStatus::STATUS_AUTHORIZED;
  }

  /**
   * Is this order line canceled?
   */
  public function isCanceled(): bool {
    return $this->status === OrderLineStatus::STATUS_CANCELED;
  }

  /**
   *(Deprecated) Is this order line refunded?
   * @deprecated 2018-11-27
   */
  <<__Deprecated('This function has been replaced at 2018-11-27', 10)>>
  public function isRefunded(): bool {
    return $this->status === OrderLineStatus::STATUS_REFUNDED;
  }

  /**
   * Is this order line shipping?
   */
  public function isShipping(): bool {
    return $this->status === OrderLineStatus::STATUS_SHIPPING;
  }

  /**
   * Is this order line completed?
   */
  public function isCompleted(): bool {
    return $this->status === OrderLineStatus::STATUS_COMPLETED;
  }

  /**
   * Is this order line for a physical product?
   */
  public function isPhysical(): bool {
    return $this->type === OrderLineType::TYPE_PHYSICAL;
  }

  /**
   * Is this order line for applying a discount?
   */
  public function isDiscount(): bool {
    return $this->type === OrderLineType::TYPE_DISCOUNT;
  }

  /**
   * Is this order line for a digital product?
   */
  public function isDigital(): bool {
    return $this->type === OrderLineType::TYPE_DIGITAL;
  }

  /**
   * Is this order line for applying a shipping fee?
   */
  public function isShippingFee(): bool {
    return $this->type === OrderLineType::TYPE_SHIPPING_FEE;
  }

  /**
   * Is this order line for store credit?
   */
  public function isStoreCredit(): bool {
    return $this->type === OrderLineType::TYPE_STORE_CREDIT;
  }

  /**
   * Is this order line for a gift card?
   */
  public function isGiftCard(): bool {
    return $this->type === OrderLineType::TYPE_GIFT_CARD;
  }

  /**
   * Is this order line for a surcharge?
   */
  public function isSurcharge(): bool {
    return $this->type === OrderLineType::TYPE_SURCHARGE;
  }

  /**
   * Update an orderline by supplying one or more parameters in the data array
   */
  public function update(): BaseResource {
    $url = 'orders/' . $this->orderId . '/lines/' . $this->id;
    $body = json_encode($this->getUpdateData());
    $result = $this->client->performHttpCall(MollieApiClient::HTTP_PATCH, $url, $body);

    return ResourceFactory::createFromApiResult($result, new Order($this->client));
  }

  /**
   * Get sanitized array of order line data
   */
  public function getUpdateData(): dict<string, mixed> {
    // Explicitly filter only NULL values to keep "vatRate => 0" intact
    return Dict\filter(dict[
      "name" => $this->name,
      'imageUrl' => $this->imageUrl,
      'productUrl' => $this->productUrl,
      'metadata' => $this->metadata,
      'quantity' => $this->quantity,
      'unitPrice' => $this->unitPrice,
      'discountAmount' => $this->discountAmount,
      'totalAmount' => $this->totalAmount,
      'vatAmount' => $this->vatAmount,
      'vatRate' => $this->vatRate,
    ], $val ==> $val !== null);
  }

  <<__Override>>
  public function parseJsonData(
    dict<string, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];
    $this->orderId = (string)$datas['orderId'];

    $this->type = OrderLineType::assert((string)$datas['type']);

    $this->name = (string)$datas['name'];

    $this->status = OrderLineStatus::assert((string)$datas['status']);

    $this->isCancelable = (bool)$datas['isCancelable'];

    $this->quantity = (int)$datas['quantity'];
    $this->quantityShipped = (int)$datas['quantityShipped'];

    $this->amountShipped = to_dict($datas['amountShipped']) |> Amount::parse($$);

    $this->quantityRefunded = (int)$datas['quantityRefunded'];

    $this->amountRefunded = to_dict($datas['amountRefunded']) |> Amount::parse($$);

    $this->quantityCanceled = (int)$datas['quantityCanceled'];

    $this->amountCanceled = to_dict($datas['amountCanceled']) |> Amount::parse($$);

    $this->shippableQuantity = (int)$datas['shippableQuantity'];
    $this->refundableQuantity = (int)$datas['refundableQuantity'];
    $this->cancelableQuantity = (int)$datas['cancelableQuantity'];

    $this->unitPrice = to_dict($datas['unitPrice']) |> Amount::parse($$);

    if(C\contains_key($datas, 'discountAmount') && $datas['discountAmount'] !== null) {
      $this->discountAmount = to_dict($datas['discountAmount']) |> Amount::parse($$);
    }

    $this->totalAmount = to_dict($datas['totalAmount']) |> Amount::parse($$);

    $this->vatRate = (float)$datas['vatRate'];

    $this->vatAmount = to_dict($datas['vatAmount']) |> Amount::parse($$);

    if(C\contains_key($datas, 'sku') && $datas['sku'] !== null) {
      $this->sku = (string)$datas['sku'];
    }

    if(C\contains_key($datas, 'imageUrl') && $datas['imageUrl'] !== null) {
      $this->imageUrl = (string)$datas['imageUrl'];
    }

    if(C\contains_key($datas, 'productUrl') && $datas['productUrl'] !== null) {
      $this->imageUrl = (string)$datas['productUrl'];
    }

    $this->metadata = $datas['metadata'];

    $this->createdAt = (string)$datas['createdAt'];

    $this->links = to_dict($datas['_links']) |> Links::parse($$);
  }
}
