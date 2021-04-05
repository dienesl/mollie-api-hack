namespace Mollie\Api\Resources;

use namespace HH\Lib\C;

final class Details {
  public ?string $bankName;
  public ?string $bankAccount;
  public ?string $bankBic;
  public ?string $transferReference;
  public ?string $consumerName;
  public ?string $consumerAccount;
  public ?string $consumerBic;
  public ?string $billingEmail;

  public static function assert(
  dict<string, mixed> $datas
  ): this {
  $details = new Details();

  if(C\contains_key($datas, 'bankName') && $datas['bankName'] !== null) {
    $details->bankName = (string)$datas['bankName'];
  }

  if(C\contains_key($datas, 'bankAccount') && $datas['bankAccount'] !== null) {
    $details->bankAccount = (string)$datas['bankAccount'];
  }

  if(C\contains_key($datas, 'bankBic') && $datas['bankBic'] !== null) {
    $details->bankBic = (string)$datas['bankBic'];
  }

  if(C\contains_key($datas, 'transferReference') && $datas['transferReference'] !== null) {
    $details->transferReference = (string)$datas['transferReference'];
  }

  if(C\contains_key($datas, 'consumerName') && $datas['consumerName'] !== null) {
    $details->consumerName = (string)$datas['consumerName'];
  }

  if(C\contains_key($datas, 'consumerAccount') && $datas['consumerAccount'] !== null) {
    $details->consumerAccount = (string)$datas['consumerAccount'];
  }

  if(C\contains_key($datas, 'consumerBic') && $datas['consumerBic'] !== null) {
    $details->consumerBic = (string)$datas['consumerBic'];
  }

  if(C\contains_key($datas, 'billingEmail') && $datas['billingEmail'] !== null) {
    $details->billingEmail = (string)$datas['billingEmail'];
  }

  return $details;
  }
}
