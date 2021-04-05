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

function to_vec_dict(
  mixed $values
): vec<dict<string, mixed>> {
  $result = vec[];

  if($values is Traversable<_>) {
  foreach($values as $value) {
    $result[] = to_dict($value);
  }
  }

  return $result;
}

function to_dict_with_vec_dict(
  mixed $values
): dict<string, vec<dict<string, mixed>>> {
  $result = dict[];

  if($values is KeyedContainer<_, _>) {
  foreach($values as $key => $value) {
    $result[(string)$key] = to_vec_dict($value);
  }
  }

  return $result;
}
