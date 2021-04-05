namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\MollieApiClient;

class ResourceFactory {
  /**
   * Create resource object from Api result
   */
  public static function createFromApiResult<T as BaseResource>(
    dict<string, mixed> $apiResult,
    T $resource
  ): T {
    $resource->assert($apiResult);

    return $resource;
  }

  public static function loadDatas<T1 as BaseResource, T2 as BaseCollection<T1>>(
    MollieApiClient $client,
    classname<T1> $resourceClass,
    T2 $resourceCollectionClass,
    vec<dict<string, mixed>> $data,
  ): T2 {
    foreach($data as $item) {
      $resourceCollectionClass->values[] = static::createFromApiResult($item, new $resourceClass($client));
    }

    return $resourceCollectionClass;
  }

  public static function createBaseResourceCollection<T1 as BaseResource, T2 as BaseCollectionBridge<T1>>(
    MollieApiClient $client,
    classname<T1> $resourceClass,
    classname<T2> $resourceCollectionClass,
    vec<dict<string, mixed>> $data,
    Links $links
  ): T2 {
    return static::loadDatas(
      $client,
      $resourceClass,
      new $resourceCollectionClass(C\count($data), $links),
      $data
    );
  }

  public static function createCursorResourceCollection<T1 as BaseResource, T2 as CursorCollection<T1>>(
    MollieApiClient $client,
    classname<T1> $resourceClass,
    classname<T2> $resourceCollectionClass,
    vec<dict<string, mixed>> $data,
    Links $links,
  ): T2 {
    return static::loadDatas(
      $client,
      $resourceClass,
      new $resourceCollectionClass($client, C\count($data), $links),
      $data
    );
  }
}
