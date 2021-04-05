namespace Mollie\Api\Resources;

use namespace HH\Lib\C;

final class Image {
  public function __construct(
    public ?string $site1x,
    public ?string $site2x,
    public ?string $svg
  ) {}

  public static function parse(
    dict<string, mixed> $datas
  ): this {
    if(C\contains_key($datas, 'site1x')) {
      $site1x = (string)$datas['site1x'];
    } else {
      $site1x = null;
    }

    if(C\contains_key($datas, 'site2x')) {
      $site2x = (string)$datas['site2x'];
    } else {
      $site2x = null;
    }

    if(C\contains_key($datas, 'svg')) {
      $svg = (string)$datas['svg'];
    } else {
      $svg = null;
    }
    
    return new Image($site1x, $site2x, $svg);
  }
}
