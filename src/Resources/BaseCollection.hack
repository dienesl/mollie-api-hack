namespace Mollie\Api\Resources;

abstract class BaseCollection {
  public function __construct(
    public int $count,
    public Links $links
  ) {}

  abstract public function getCollectionResourceName(): ?string;
}
