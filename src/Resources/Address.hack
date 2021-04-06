namespace Mollie\Api\Resources;

final class Address {
  public function __construct(
    public string $organizationName,
    public string $streetAndNumber,
    public string $postalCode,
    public string $city,
    public string $country,
    public string $givenName,
    public string $familyName,
    public string $email
  ) {}

  public static function assert(
    dict<string, mixed> $datas
  ): this {
    return new Address(
      (string)$datas['organizationName'],
      (string)$datas['streetAndNumber'],
      (string)$datas['postalCode'],
      (string)$datas['city'],
      (string)$datas['country'],
      (string)$datas['givenName'],
      (string)$datas['familyName'],
      (string)$datas['email']
    );
  }
}
