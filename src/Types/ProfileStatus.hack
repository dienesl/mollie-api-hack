namespace Mollie\Api\Types;

enum ProfileStatus: string {
  /**
   * The profile has not been verified yet and can only be used to create test payments.
   */
  STATUS_UNVERIFIED = 'unverified';

  /**
   * The profile has been verified and can be used to create live payments and test payments.
   */
  STATUS_VERIFIED = 'verified';

  /**
   * The profile is blocked and can thus no longer be used or changed.
   */
  STATUS_BLOCKED = 'blocked';
}
