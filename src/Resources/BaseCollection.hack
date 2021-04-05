namespace Mollie\Api\Resources;

abstract class BaseCollection<T as BaseResource> {
  public vec<T> $values = vec[];

  public function __construct(
  public int $count,
  public Links $links
  ) {}

  abstract public function getCollectionResourceName(): ?string;
}
