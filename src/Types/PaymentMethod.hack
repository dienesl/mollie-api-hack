namespace Mollie\Api\Types;

enum PaymentMethod: string {
  /**
   * @link https://www.mollie.com/en/payments/applepay
   */
  APPLEPAY = 'applepay';

  /**
   * @link https://www.mollie.com/en/payments/bancontact
   */
  BANCONTACT = 'bancontact';

  /**
   * @link https://www.mollie.com/en/payments/bank-transfer
   */
  BANKTRANSFER = 'banktransfer';

  /**
   * @link https://www.mollie.com/en/payments/belfius
   */
  BELFIUS = 'belfius';

  /**
   * @deprecated 2019-05-01
   */
  BITCOIN = 'bitcoin';

  /**
   * @link https://www.mollie.com/en/payments/credit-card
   */
  CREDITCARD = 'creditcard';

  /**
   * @link https://www.mollie.com/en/payments/direct-debit
   */
  DIRECTDEBIT = 'directdebit';

  /**
   * @link https://www.mollie.com/en/payments/eps
   */
  EPS = 'eps';

  /**
   * @link https://www.mollie.com/en/payments/gift-cards
   */
  GIFTCARD = 'giftcard';

  /**
   * @link https://www.mollie.com/en/payments/giropay
   */
  GIROPAY = 'giropay';

  /**
   * @link https://www.mollie.com/en/payments/ideal
   */
  IDEAL = 'ideal';

  /**
   * Support for inghomepay will be discontinued February 1st, 2021.
   * Make sure to remove this payment method from your checkout if needed.
   *
   * @deprecated
   * @link https://docs.mollie.com/changelog/v2/changelog
   *
   */
  INGHOMEPAY = 'inghomepay';

  /**
   * @link https://www.mollie.com/en/payments/kbc-cbc
   */
  KBC = 'kbc';

  /**
   * @link https://www.mollie.com/en/payments/klarna-pay-later
   */
  KLARNA_PAY_LATER = 'klarnapaylater';

  /**
   * @link https://www.mollie.com/en/payments/klarna-slice-it
   */
  KLARNA_SLICE_IT = 'klarnasliceit';

  /**
   * @link https://www.mollie.com/en/payments/mybank
   */
  MYBANK = 'mybank';

  /**
   * @link https://www.mollie.com/en/payments/paypal
   */
  PAYPAL = 'paypal';

  /**
   * @link https://www.mollie.com/en/payments/paysafecard
   */
  PAYSAFECARD = 'paysafecard';

  /**
   * @link https://www.mollie.com/en/payments/przelewy24
   */
  PRZELEWY24 = 'przelewy24';

  /**
   * @deprecated
   * @link https://www.mollie.com/en/payments/gift-cards
   */
  PODIUMCADEAUKAART = 'podiumcadeaukaart';

  /**
   * @link https://www.mollie.com/en/payments/sofort
   */
  SOFORT = 'sofort';
}
