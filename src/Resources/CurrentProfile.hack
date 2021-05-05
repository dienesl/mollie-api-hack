namespace Mollie\Api\Resources;

class CurrentProfile extends Profile {
  /**
   * Enable a payment method for this profile.
   */
  <<__Override>>
  public function enableMethodAsync(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<Method> {
    return $this->client->profileMethods->createForCurrentProfileAsync($methodId, $data);
  }

  /**
   * Disable a payment method for this profile.
   */
  <<__Override>>
  public function disableMethodAsync(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Awaitable<?Method> {
    return $this->client->profileMethods->deleteForCurrentProfileAsync($methodId, $data);
  }
}
