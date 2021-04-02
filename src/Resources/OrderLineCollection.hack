namespace Mollie\Api\Resources;

class OrderLineCollection extends BaseCollection {
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
    /* TODO
    foreach($this as $line) {
      if($line->id === $lineId) {
        return $line;
      }
    }
    */

    return null;
  }
}
