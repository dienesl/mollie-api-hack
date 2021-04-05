namespace Mollie\Api\Endpoints;

use namespace HH\Lib\{
  C,
  Str
};
use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\Types\RestMethod;
use function Mollie\Api\Functions\to_dict;
use function json_encode;
use function urlencode;

class PaymentEndpoint extends CollectionEndpointAbstract<Resources\Payment, Resources\PaymentCollection> {
  const string RESOURCE_ID_PREFIX = 'tr_';

  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'payments';
  }

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
   * Creates a payment in Mollie.
   */
  public function create(
    dict<arraykey, mixed> $data = dict[],
    dict<arraykey, mixed> $filters = dict[]
  ): Resources\Payment {
    return $this->restCreate($data, $filters);
  }

  /**
   * Retrieve a single payment from Mollie.
   *
   * Will throw a ApiException if the payment id is invalid or the resource cannot be found.
   */
  public function get(
    string $paymentId,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Payment {
    if(Str\is_empty($paymentId) || Str\search($paymentId, self::RESOURCE_ID_PREFIX) !== 0) {
      throw new ApiException('Invalid payment ID: \'' . $paymentId . '\'. A payment ID should start with \'' .self::RESOURCE_ID_PREFIX . '\'.');
    }

    return $this->restRead($paymentId, $parameters);
  }

  /**
   * Deletes the given Payment.
   *
   * Will throw a ApiException if the payment id is invalid or the resource cannot be found.
   * Returns with HTTP status No Content(204) if successful.
   */
  public function delete(
    string $paymentId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Payment {
    return $this->restDelete($paymentId, $data);
  }

  /**
   * Cancel the given Payment. This is just an alias of the 'delete' method.
   *
   * Will throw a ApiException if the payment id is invalid or the resource cannot be found.
   * Returns with HTTP status No Content(204) if successful.
   */
  public function cancel(
    string $paymentId,
    dict<arraykey, mixed> $data = dict[]
  ): ?Resources\Payment {
    //return $this->restDelete($paymentId, $data);
    return $this->delete($paymentId, $data);
  }

  /**
   * Retrieves a collection of Payments from Mollie.
   */
  public function page(
    ?string $from = null,
    ?int $limit = null,
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\PaymentCollection {
    return $this->restList($from, $limit, $parameters);
  }

  /**
   * Issue a refund for the given payment.
   *
   * The $data parameter may either be an array of endpoint parameters, a float value to
   * initiate a partial refund, or empty to do a full refund.
   *
   * @param Payment $payment
   * @param array|float|null $data
   *
   * @return Refund
   * @throws ApiException
   */
  public function refund(
    Resources\Payment $payment,
    dict<arraykey, mixed> $data = dict[]
  ): Resources\Refund {
    $resource = $this->getResourcePath() . '/' . urlencode($payment->id) . '/refunds';

    $body = null;
    if(C\count($data) > 0) {
      $body = json_encode($data);
    }

    $result = $this->client->performHttpCall(RestMethod::CREATE, $resource, $body);

    return Resources\ResourceFactory::createFromApiResult(
      to_dict($result),
      new Resources\Refund($this->client)
    );
  }
}
