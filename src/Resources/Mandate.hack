namespace Mollie\Api\Resources;

use type Mollie\Api\Types\{
  MandateStatus,
  HttpMethod
};
use function Mollie\Api\Functions\to_dict;
use function json_encode;

class Mandate extends BaseResource {
  <<__LateInit>>
  public string $resource;

  <<__LateInit>>
  public string $id;

  <<__LateInit>>
  public MandateStatus $status;

  <<__LateInit>>
  public string $mode;

  <<__LateInit>>
  public string $method;

  <<__LateInit>>
  public Details $details;

  <<__LateInit>>
  public string $customerId;

  <<__LateInit>>
  public string $createdAt;

  <<__LateInit>>
  public string $mandateReference;

  /**
   * Date of signature, for example: 2018-05-07
   */
  <<__LateInit>>
  public string $signatureDate;

  <<__LateInit>>
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
   */
  public async function revokeAsync(): Awaitable<void> {
    $selfLink = $this->links->self;
    if($selfLink !== null) {
      $body = null;
      if($this->client->usesOAuth()) {
        $body = json_encode(dict[
          'testmode' => $this->mode === 'test' ? true : false,
        ]);
      }

      await $this->client->performHttpCallToFullUrlAsync(
        HttpMethod::DELETE,
        $selfLink->href,
        $body
      );
    }
  }

  <<__Override>>
  public function assert(
    dict<arraykey, mixed> $datas
  ): void {
    $this->resource = (string)$datas['resource'];
    $this->id = (string)$datas['id'];

    $this->status = MandateStatus::assert((string)$datas['status']);

    $this->mode = (string)$datas['mode'];
    $this->method = (string)$datas['method'];

    $this->details = to_dict($datas['details']) |> Details::assert($$);

    $this->customerId = (string)$datas['customerId'];
    $this->createdAt = (string)$datas['createdAt'];
    $this->mandateReference = (string)$datas['mandateReference'];
    $this->signatureDate = (string)$datas['signatureDate'];

    $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
