namespace Mollie\Api\Resources;

class InvoiceCollection extends CursorCollection {
  public function getCollectionResourceName(): string {
    return 'invoices';
  }

  protected function createResourceObject(): BaseResource {
    return new Invoice($this->client);
  }
}
