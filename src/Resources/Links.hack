namespace Mollie\Api\Resources;

use namespace HH\Lib\C;

final class Links {
  public ?Link $captures;

  public ?Link $chargebacks;

  public ?Link $checkout;

  public ?Link $dashboard;

  public ?Link $documentation;

  public ?Link $image;

  public ?Link $methods;

  public ?Link $next;

  public ?Link $payments;

  public ?Link $previous;

  public ?Link $product;

  public ?Link $refunds;

  public ?Link $self;

  public static function parse(
    dict<string, mixed> $datas
  ): this {
    $links = new Links();
    
    if(C\contains_key($datas, 'captures')) {
      $captures = $datas['captures'];
      if($captures is KeyedContainer<_, _>) {
        $links->captures = new Link(
          (string)$captures['href'],
          (string)$captures['type']
        );
      }
    }
    
    if(C\contains_key($datas, 'chargebacks')) {
      $captures = $datas['captures'];
      if($captures is KeyedContainer<_, _>) {
        $links->captures = new Link(
          (string)$captures['href'],
          (string)$captures['type']
        );
      }
    }

    return $links;
  }
}
