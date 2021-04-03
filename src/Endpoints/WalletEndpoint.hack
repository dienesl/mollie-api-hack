namespace Mollie\Api\Endpoints;

use Mollie\Api\Resources\BaseResource;

use namespace Mollie\Api\Resources;
use type Mollie\Api\Types\RestMethod;
use function json_encode;

class WalletEndpoint extends EndpointAbstract<Resources\VoidResource, Resources\VoidResourceCollection> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = '';
  }
  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\VoidResource {
    // Not used
    return new Resources\VoidResource($this->client);
  }

  public function requestApplePayPaymentSession(
    string $domain,
    string $validationUrl
  ): string {
    $body = $this->parseRequestBody(dict[
      'domain' => $domain,
      'validationUrl' => $validationUrl,
    ]);

    $response = $this->client->performHttpCall(
      RestMethod::CREATE,
      'wallets/applepay/sessions',
      $body
    );

    return json_encode($response);
  }
}
