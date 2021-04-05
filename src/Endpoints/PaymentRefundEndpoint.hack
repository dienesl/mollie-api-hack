namespace Mollie\Api\Endpoints;

use Mollie\Api\Resources\Payment;
use Mollie\Api\Resources\Refund;
use Mollie\Api\Resources\RefundCollection;

use namespace Mollie\Api\Resources;

class PaymentRefundEndpoint extends CollectionEndpointAbstract<Resources\Refund, Resources\RefundCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
  $this->resourcePath = 'payments_refunds';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Refund {
  return new Resources\Refund($this->client);
  }

  /**
   * Get the collection object that is used by this API endpoint. Every API endpoint uses one type of collection object.
   */
  <<__Override>>
  protected function getResourceCollectionObject(
  int $count,
  Resources\Links $links
  ): Resources\RefundCollection {
  return new Resources\RefundCollection($this->client, $count, $links);
  }

  public function getFor(
  Resources\Payment $payment,
  string $refundId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Refund {
  return $this->getForId($payment->id, $refundId, $parameters);
  }

  public function getForId(
  string $paymentId,
  string $refundId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Refund {
  $this->parentId = $paymentId;

  return $this->restRead($refundId, $parameters);
  }

  public function listFor(
  Resources\Payment $payment,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\RefundCollection {
  return $this->listForId($payment->id, $parameters);
  }

  public function listForId(
  string $paymentId,
  dict<arraykey, mixed> $parameters = dict[]
  ): Resources\RefundCollection {
  $this->parentId = $paymentId;

  return $this->restList(null, null, $parameters);
  }
}
