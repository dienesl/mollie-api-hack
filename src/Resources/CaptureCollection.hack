namespace Mollie\Api\Resources;

class CaptureCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'captures';
  }

  protected function createResourceObject(): BaseResource {
    return new Capture($this->client);
  }
}
