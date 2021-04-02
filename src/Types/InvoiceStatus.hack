namespace Mollie\Api\Types;

enum InvoiceStatus: string {
  /**
   * The invoice is not paid yet.
   */
  STATUS_OPEN = 'open';

  /**
   * The invoice is paid.
   */
  STATUS_PAID = 'paid';

  /**
   * Payment of the invoice is overdue.
   */
  STATUS_OVERDUE = 'overdue';
}
