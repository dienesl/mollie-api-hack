namespace Mollie\Api\Resources;

class InvoiceCollection extends CursorCollection<Invoice> {
  public function getCollectionResourceName(): string {
    return 'invoices';
  }

  protected function createResourceObject(): Invoice {
    return new Invoice($this->client);
  }
}
