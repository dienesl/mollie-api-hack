namespace Mollie\Api\Resources;

class CaptureCollection extends CursorCollection<Capture> {
  <<__Override>>
  public function getCollectionResourceName(): string {
  return 'captures';
  }

  <<__Override>>
  protected function createResourceObject(): Capture {
  return new Capture($this->client);
  }
}
