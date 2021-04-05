namespace Mollie\Api\Resources;

use namespace HH\Lib\C;

final class Tracking {
  public function __construct(
    public string $carrier,
    public string $code,
    public ?string $url
  ) {}

  public static function assert(
    dict<string, mixed> $datas
  ): this {
    return new Tracking(
      (string)$datas['carrier'],
      (string)$datas['code'],
      C\contains_key($datas, 'url') && $datas['url'] !== null ? (string)$datas['url'] : null
    );
  }
}
