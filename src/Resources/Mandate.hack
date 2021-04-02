namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;
use type Mollie\Api\Types\MandateStatus;
use function json_encode;

class Mandate extends BaseResource {
  public string $resource;

  public string $id;

  public MandateStatus $status;

  public string $mode;

  public string $method;

  /**
   * @var \stdClass|null
   * TODO
   */
  public mixed $details;

  public string $customerId;

  public string $createdAt;

  public string $mandateReference;

  /**
   * Date of signature, for example: 2018-05-07
   */
  public string $signatureDate;

  public Links $links; 
  public function isValid(): bool {
    return $this->status === MandateStatus::STATUS_VALID;
  }

  public function isPending(): bool {
    return $this->status === MandateStatus::STATUS_PENDING;
  }

  public function isInvalid(): bool {
    return $this->status === MandateStatus::STATUS_INVALID;
  }

  /**
   * Revoke the mandate
   *
   * @return null
   */
  public function revoke(): this {
    if($this->links->self !== null) {
      return $this;
    }

    $body = null;
    if($this->client->usesOAuth()) {
      $body = json_encode(dict[
        'testmode' => $this->mode === 'test' ? true : false,
      ]);
    }

    $result = $this->client->performHttpCallToFullUrl(
      MollieApiClient::HTTP_DELETE,
      $this->links->self->href,
      $body
    );

    return $result;
  }
}
