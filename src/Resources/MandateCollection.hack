namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Types\MandateStatus;

class MandateCollection extends CursorCollection<Mandate> {
  public function getCollectionResourceName(): string {
  return 'mandates';
  }

  protected function createResourceObject(): Mandate {
  return new Mandate($this->client);
  }

  public function whereStatus(
  MandateStatus $status
  ): MandateCollection {
  $items = vec[];

  foreach($this->values as $item) {
    if($item->status === $status) {
    $items[] = $item;
    }
  }
  
  $collection = new self($this->client, C\count($items), $this->links);
  $collection->values = $items;
  return $collection;
  }
}
