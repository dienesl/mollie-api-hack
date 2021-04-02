namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;

abstract class BaseResource {
  public function __construct(
    protected MollieApiClient $client
  ) {}
}
