namespace Mollie\Api\Resources;

class Image {
  public function __construct(
    public ?string $site1x,
    public ?string $site2x,
    public ?string $svg
  ) {}
}
