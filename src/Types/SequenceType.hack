namespace Mollie\Api\Types;

enum SequenceType: string {
  /**
   * Sequence types.
   *
   * @see https://docs.mollie.com/guides/recurring
   */
  SEQUENCETYPE_ONEOFF = 'oneoff';
  SEQUENCETYPE_FIRST = 'first';
  SEQUENCETYPE_RECURRING = 'recurring';
}
