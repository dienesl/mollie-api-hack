namespace Mollie\Api\Resources;

final class ApplicationFee {
  public function __construct(
    public ?string $desription,
    public Amount $amount 
  ) {}
}

