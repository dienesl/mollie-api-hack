namespace Mollie\Api\Functions;

function to_dict(
  mixed $values
): dict<string, mixed> {
  $result = dict[];

  if($values is KeyedContainer<_, _>) {
    foreach($values as $key => $value) {
      $result[(string)$key] = $value;
    }
  }
  
  return $result;
}

function to_dict_with_vec_dict(
  mixed $values
): dict<string, vec<dict<string, mixed>>> {
  $result = dict[];

  if($values is KeyedContainer<_, _>) {
    foreach($values as $key => $values) {
      $vec = vec[];
      if($values is Traversable<_>) {
        foreach($values as $value) {
          $dict = dict[];
          if($value is KeyedContainer<_, _>) {
            foreach($value as $key2 => $value2) {
              $dict[(string)$key2] = $value2;
            }
          }
          $vec[] = $dict;
        }
      }
      $result[(string)$key] = $vec;
    }
  }
  
  return $result;
}
