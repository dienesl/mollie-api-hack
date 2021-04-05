namespace Mollie\Api\Resources;

use namespace HH\Lib\C;

final class Links {
  public ?Link $captures;

  public ?Link $chargebacks;

  public ?Link $checkout;

  public ?Link $dashboard;

  public ?Link $documentation;

  public ?Link $imageUrl;

  public ?Link $methods;

  public ?Link $next;

  public ?Link $payments;

  public ?Link $pdf;

  public ?Link $previous;

  public ?Link $productUrl;

  public ?Link $refunds;

  public ?Link $self;

  public static function assert(
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
    $chargebacks = $datas['chargebacks'];
    if($chargebacks is KeyedContainer<_, _>) {
    $links->chargebacks = new Link(
      (string)$chargebacks['href'],
      (string)$chargebacks['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'checkout')) {
    $checkout = $datas['checkout'];
    if($checkout is KeyedContainer<_, _>) {
    $links->checkout = new Link(
      (string)$checkout['href'],
      (string)$checkout['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'dashboard')) {
    $dashboard = $datas['dashboard'];
    if($dashboard is KeyedContainer<_, _>) {
    $links->dashboard = new Link(
      (string)$dashboard['href'],
      (string)$dashboard['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'documentation')) {
    $documentation = $datas['documentation'];
    if($documentation is KeyedContainer<_, _>) {
    $links->documentation = new Link(
      (string)$documentation['href'],
      (string)$documentation['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'imageUrl')) {
    $imageUrl = $datas['imageUrl'];
    if($imageUrl is KeyedContainer<_, _>) {
    $links->imageUrl = new Link(
      (string)$imageUrl['href'],
      (string)$imageUrl['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'methods')) {
    $methods = $datas['methods'];
    if($methods is KeyedContainer<_, _>) {
    $links->methods = new Link(
      (string)$methods['href'],
      (string)$methods['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'next')) {
    $next = $datas['next'];
    if($next is KeyedContainer<_, _>) {
    $links->next = new Link(
      (string)$next['href'],
      (string)$next['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'payments')) {
    $payments = $datas['payments'];
    if($payments is KeyedContainer<_, _>) {
    $links->payments = new Link(
      (string)$payments['href'],
      (string)$payments['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'pdf')) {
    $pdf = $datas['pdf'];
    if($pdf is KeyedContainer<_, _>) {
    $links->pdf = new Link(
      (string)$pdf['href'],
      (string)$pdf['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'previous')) {
    $previous = $datas['previous'];
    if($previous is KeyedContainer<_, _>) {
    $links->previous = new Link(
      (string)$previous['href'],
      (string)$previous['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'productUrl')) {
    $productUrl = $datas['productUrl'];
    if($productUrl is KeyedContainer<_, _>) {
    $links->productUrl = new Link(
      (string)$productUrl['href'],
      (string)$productUrl['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'refunds')) {
    $refunds = $datas['refunds'];
    if($refunds is KeyedContainer<_, _>) {
    $links->refunds = new Link(
      (string)$refunds['href'],
      (string)$refunds['type']
    );
    }
  }
  
  if(C\contains_key($datas, 'self')) {
    $self = $datas['self'];
    if($self is KeyedContainer<_, _>) {
    $links->self = new Link(
      (string)$self['href'],
      (string)$self['type']
    );
    }
  }

  return $links;
  }
}
