namespace Mollie\Api\Types;

enum OrderLineType: string {
  TYPE_PHYSICAL = 'physical';
  TYPE_DISCOUNT = 'discount';
  TYPE_DIGITAL = 'digital';
  TYPE_SHIPPING_FEE = 'shipping_fee';
  TYPE_STORE_CREDIT = 'store_credit';
  TYPE_GIFT_CARD = 'gift_card';
  TYPE_SURCHARGE = 'surcharge';
}
