namespace Mollie\Api\Endpoints;

use namespace Mollie\Api\Resources;
use type Mollie\Api\Exceptions\ApiException;
use type Mollie\Api\Types\RestMethod;
use function Mollie\Api\Functions\to_dict;

class OnboardingEndpoint extends EndpointAbstract<Resources\Onboarding> {
  <<__Override>>
  protected function setResourcePath(): void {
    $this->resourcePath = 'onboarding/me';
  }

  /**
   * Get the object that is used by this API endpoint. Every API endpoint uses one type of object.
   */
  <<__Override>>
  protected function getResourceObject(): Resources\Onboarding {
    return new Resources\Onboarding($this->client);
  }

  //<<__Override>>
  protected function getResourceCollectionObject(
    int $count,
    Resources\Links $links
  ): Resources\OnboardingCollection {
    throw  new ApiException('not implemnted.');
    //return new Resources\OnboardingCollection($this->client, $count, $links);
  }

  /**
   * Retrieve the organization's onboarding status from Mollie.
   *
   * Will throw a ApiException if the resource cannot be found.
   */
  public function get(): Resources\Onboarding {
    return $this->restRead('', dict[]);
  }

  /**
   * Submit data that will be prefilled in the merchant’s onboarding.
   * Please note that the data you submit will only be processed when the onboarding status is needs-data.
   *
   * Information that the merchant has entered in their dashboard will not be overwritten.
   *
   * Will throw a ApiException if the resource cannot be found.
   */
  public function submit(
    dict<arraykey, mixed> $parameters = dict[]
  ): Resources\Onboarding {
    return $this->restCreate($parameters, dict[]);
  }

  <<__Override>>
  protected function restRead(
    string $id,
    dict<arraykey, mixed> $filters
  ): Resources\Onboarding {
    $result = $this->client->performHttpCall(
      RestMethod::READ,
      $this->getResourcePath() . $this->buildQueryString($filters)
    );

    return Resources\ResourceFactory::createFromApiResult(
      to_dict($result),
      $this->getResourceObject()
    );
  }
}
