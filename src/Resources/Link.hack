namespace Mollie\Api\Resources;

final class Link {
  public function __construct(
  public string $href,
  public string $type
  ) {}
}
