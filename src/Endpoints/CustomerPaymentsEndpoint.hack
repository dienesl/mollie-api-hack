namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;

class CustomerPaymentsEndpoint extends CollectionEndpointAbstract<Resources\Payment, Resources\PaymentCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'customers_payments';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Payment {
    return new Resources\Payment($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\PaymentCollection {
    return new Resources\PaymentCollection($this->client, $count, $links);
  }

  /**
   * Create a subscription for a Customer
   */
  public function createForAsync(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Payment> {
    return $this->createForIdAsync($customer->id, $options, $filters);
  }

  /**
   * Create a subscription for a Customer ID
   */
  public function createForIdAsync(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Awaitable<Resources\Payment> {
    $this->parentId = $customerId;

    return parent::restCreateAsync($options, $filters);
  }

  public function listForAsync(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\PaymentCollection> {
    return $this->listForIdAsync($customer->id, $from, $limit, $parameters);
  }

  /**
   * @param string $from The first resource ID you want to include in your list.
   */
  public function listForIdAsync(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Awaitable<Resources\PaymentCollection> {
    $this->parentId = $customerId;

    return parent::restListAsync($from, $limit, $parameters);
  }
}
