namespace Mollie\Api\Resources;

use type Mollie\Api\MollieApiClient;

<<__ConsistentConstruct>>
abstract class BaseResource {
  public function __construct(
    protected MollieApiClient $client
  ) {}
}
