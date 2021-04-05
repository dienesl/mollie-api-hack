namespace Mollie\Api\Resources;

use function Mollie\Api\Functions\to_dict;

final class Line {
  public function __construct(
    public string $period,
    public string $description,
    public int $count,
    public float $vatPercentage,
    public Amount $amount
  ) {}

  public static function parse(
    dict<string, mixed> $datas
  ): this {
    return new Line(
      (string)$datas['period'],
      (string)$datas['description'],
      (int)$datas['count'],
      (float)$datas['varPercentage'],
      to_dict($datas['amount']) |> Amount::parse($$)
    );
  }
}
