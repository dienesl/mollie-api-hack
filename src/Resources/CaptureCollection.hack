namespace Mollie\Api\Resources;

class CaptureCollection extends CursorCollection<Capture> {
  public function getCollectionResourceName(): string {
  return 'captures';
  }

  protected function createResourceObject(): Capture {
  return new Capture($this->client);
  }
}
