namespace Mollie\Api\Resources;

class InvoiceCollection extends CursorCollection<Invoice> {
  <<__Override>>
  public function getCollectionResourceName(): string {
    return 'invoices';
  }

  <<__Override>>
  protected function createResourceObject(): Invoice {
    return new Invoice($this->client);
  }
}
