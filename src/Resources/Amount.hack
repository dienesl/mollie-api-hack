namespace Mollie\Api\Resources;

final class Amount {
  public function __construct(
    public float $value,
    public string $currency
  ) {}
}
