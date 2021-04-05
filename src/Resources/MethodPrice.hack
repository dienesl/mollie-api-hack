namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use function Mollie\Api\Functions\to_dict;

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
  public float $variable;

  public ?string $feeRegion;

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->description = (string)$datas['description'];

  $this->fixed = to_dict($datas['fixed']) |> Amount::assert($$);

  $this->variable = (float)$datas['variable'];

  if(C\contains_key($datas, 'feeRegion') && $datas['feeRegion'] !== null) {
    $this->feeRegion = (string)$datas['feeRegion'];
  }
  }
}
