namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use function Mollie\Api\Functions\to_dict;

final class ApplicationFee {
  public function __construct(
  public ?string $desription,
  public Amount $amount
  ) {}

  public static function assert(
  dict<string, mixed> $datas
  ): this {
  if(C\contains_key($datas, 'desription') && $datas['description'] !== null) {
    $description = (string)$datas['description'];
  } else {
    $description = null;
  }

  return new ApplicationFee(
    $description,
    to_dict($datas['amount']) |> Amount::assert($$)
  );
  }
}
