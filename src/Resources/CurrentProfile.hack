namespace Mollie\Api\Resources;

class CurrentProfile extends Profile {
  /**
   * Enable a payment method for this profile.
   */
  public function enableMethod(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Method {
    return $this->client->profileMethods->createForCurrentProfile($methodId, $data);
  }

  /**
   * Disable a payment method for this profile.
   */
  public function disableMethod(
    string $methodId,
    dict<arraykey, mixed> $data = dict[]
  ): Method {
    return $this->client->profileMethods->deleteForCurrentProfile($methodId, $data);
  }
}
