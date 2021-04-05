namespace Mollie\Api\Resources;

final class Amount {
  public function __construct(
    public float $value,
    public string $currency
  ) {}

  public static function parse(
    dict<string, mixed> $datas
  ): this {
    return new Amount(
      (float)$datas['value'],
      (string)$datas['currency']
    );
  }
}
