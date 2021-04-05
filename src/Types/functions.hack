namespace Mollie\Api\Types;

function getForFirstPaymentMethod(
  PaymentMethod $firstPaymentMethod
): MandateMethod {
  if($firstPaymentMethod === PaymentMethod::PAYPAL) {
  return MandateMethod::PAYPAL;
  } else if($firstPaymentMethod === PaymentMethod::APPLEPAY) {
  return MandateMethod::CREDITCARD;
  } else if($firstPaymentMethod === PaymentMethod::CREDITCARD) {
  return MandateMethod::CREDITCARD;
  } else {
  return MandateMethod::DIRECTDEBIT;
  }
}
