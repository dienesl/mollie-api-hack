namespace Mollie\Api\Resources;

class OrderLineCollection extends BaseCollectionBridge<OrderLine> {
  <<__Override>>
  public function getCollectionResourceName(): ?string {
  return null;
  }

  /**
   * Get a specific order line.
   * Returns null if the order line cannot be found.
   */
  public function get(
  string $lineId
  ): ?OrderLine {
  foreach($this->values as $line) {
    if($line->id === $lineId) {
    return $line;
    }
  }

  return null;
  }
}
