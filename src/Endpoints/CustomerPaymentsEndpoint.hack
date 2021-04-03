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
  protected function getResourceObject(): Resources\Payment {
    return new Resources\Payment($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\PaymentCollection {
    return new Resources\PaymentCollection($this->client, $count, $links);
  }

  /**
   * Create a subscription for a Customer
   *
   * @param Customer $customer
   * @param array $options
   * @param array $filters
   *
   * @return Payment
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function createFor(
    Resources\Customer $customer,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Payment {
    return $this->createForId($customer->id, $options, $filters);
  }

  /**
   * Create a subscription for a Customer ID
   */
  public function createForId(
    string $customerId,
    dict<arraykey, mixed> $options = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Payment {
    $this->parentId = $customerId;

    return parent::restCreate($options, $filters);
  }

  public function listFor(
    Resources\Customer $customer,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\PaymentCollection {
    return $this->listForId($customer->id, $from, $limit, $parameters);
  }

  /**
   * @param string $customerId
   * @param string $from The first resource ID you want to include in your list.
   * @param int $limit
   * @param array $parameters
   *
   * @return \Mollie\Api\Resources\BaseCollection|\Mollie\Api\Resources\PaymentCollection
   * @throws \Mollie\Api\Exceptions\ApiException
   */
  public function listForId(
    string $customerId,
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\PaymentCollection {
    $this->parentId = $customerId;

    return parent::restList($from, $limit, $parameters);
  }
}
