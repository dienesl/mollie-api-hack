namespace Mollie\Api\Types;

enum SettlementStatus: string {
  /**
   * The settlement has not been closed yet.
   */
  STATUS_OPEN = 'open';

  /**
   * The settlement has been closed and is being processed.
   */
  STATUS_PENDING = 'pending';

  /**
   * The settlement has been paid out.
   */
  STATUS_PAIDOUT = 'paidout';

  /**
   * The settlement could not be paid out.
   */
  STATUS_FAILED = 'failed';
}
