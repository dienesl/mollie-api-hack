namespace Mollie\Api\Resources;

class MandateCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'mandates';
  }

  protected function createResourceObject(): BaseResource {
    return new Mandate($this->client);
  }

  /**
   * @param string $status
   * @return array|\Mollie\Api\Resources\MandateCollection
   * TODO
   */
  public function whereStatus(
    string $status
  ): mixed {
    $collection = new self($this->client, $this->count, $this->links);

    foreach($this as $item) {
      if($item->status === $status) {
        $collection[] = $item;
      }
    }

    return $collection;
  }
}
