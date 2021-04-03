namespace Mollie\Api\Resources;

class MethodPrice extends BaseResource {
  /**
   * The area or product-type where the pricing is applied for, translated in the optional locale passed.
   *
   * @example "The Netherlands"
   */
  <<__LateInit>>
  public string $description;

  /**
   * The fixed price per transaction. This excludes the variable amount.
   */
  <<__LateInit>>
  public Amount $fixed;

  /**
   * A string containing the percentage being charged over the payment amount besides the fixed price.
   *
   * @var string An string representing the percentage as a float(for example: "0.1" for 10%)
   */
  <<__LateInit>>
  public string $variable;
}
