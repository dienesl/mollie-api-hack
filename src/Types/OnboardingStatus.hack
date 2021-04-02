namespace Mollie\Api\Types;

enum OnboardingStatus: string {
  /**
   * The onboarding is not completed and the merchant needs to provide (more) information
   */
  NEEDS_DATA = 'needs-data';

  /**
   * The merchant provided all information and Mollie needs to check this
   */
  IN_REVIEW = 'in-review';

  /**
   * The onboarding is completed
   */
  COMPLETED = 'completed';
}
