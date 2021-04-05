namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class InvoiceEndpoint extends CollectionEndpointAbstract<Resources\Invoice, Resources\InvoiceCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'invoices';
  }

  /**
   * Get the object that is used by this API. Every API uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Invoice {
    return new Resources\Invoice($this->client);
  }

  /**
   * Get the collection object that is used by this API. Every API uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\InvoiceCollection {
    return new Resources\InvoiceCollection($this->client, $count, $links);
  }

  /**
   * Retrieve an Invoice from Mollie.
   *
   * Will throw a ApiException if the invoice id is invalid or the resource cannot be found.
   */
  public function getAsync(
    string $invoiceId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\Invoice> {
    return $this->restReadAsync($invoiceId, $parameters);
  }

  /**
   * Retrieves a collection of Invoices from Mollie.
   */
  public function pageAsync(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\InvoiceCollection> {
    return $this->restListAsync($from, $limit, $parameters);
  }

  /**
   * This is a wrapper method for page
   */
  public function allAsync(
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\InvoiceCollection> {
    return $this->pageAsync(null, null, $parameters);
  }
}
