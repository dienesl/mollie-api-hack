namespace Mollie\Api\Resources;

use namespace HH\Lib\C;
use type Mollie\Api\Types\InvoiceStatus;
use function Mollie\Api\Functions\to_dict;

class Invoice extends BaseResource {
  <<__LateInit>>
  public string $resource;

  <<__LateInit>>
  public string $id;

  <<__LateInit>>
  public string $reference;

  <<__LateInit>>
  public string $vatNumber;

  <<__LateInit>>
  public InvoiceStatus $status;

  /**
   * Date the invoice was issued, e.g. 2018-01-01
   */
  <<__LateInit>>
  public string $issuedAt;

  /**
   * Date the invoice was paid, e.g. 2018-01-01
   */
  public ?string $paidAt;

  /**
   * Date the invoice is due, e.g. 2018-01-01
   */
  public ?string $dueAt;

  /**
   * Amount object containing the total amount of the invoice excluding VAT.
   */
  <<__LateInit>>
  public Amount $netAmount;

  /**
   * Amount object containing the VAT amount of the invoice. Only for merchants registered in the Netherlands.
   */
  <<__LateInit>>
  public Amount $vatAmount;

  /**
   * Total amount of the invoice including VAT.
   */
  <<__LateInit>>
  public Amount $grossAmount;

  /**
   * Object containing the invoice lines.
   * See https://docs.mollie.com/reference/v2/invoices-api/get-invoice for reference
   */
  <<__LateInit>>
  public vec<Line> $lines;

  /**
   * Contains a PDF to the Invoice
   */
  <<__LateInit>>
  public Links $links;

  public function isPaid(): bool {
  return $this->status === InvoiceStatus::STATUS_PAID;
  }

  public function isOpen(): bool {
  return $this->status === InvoiceStatus::STATUS_OPEN;
  }

  public function isOverdue(): bool {
  return $this->status === InvoiceStatus::STATUS_OVERDUE;
  }

  <<__Override>>
  public function assert(
  dict<string, mixed> $datas
  ): void {
  $this->reference = (string)$datas['reference'];
  $this->id = (string)$datas['id'];
  $this->reference = (string)$datas['reference'];
  $this->vatNumber = (string)$datas['vatNumber'];

  $this->status = InvoiceStatus::assert((string)$datas['status']);

  $this->issuedAt = (string)$datas['issuedAt'];

  if(C\contains_key($datas, 'paidAt')) {
    $this->paidAt = (string)$datas['paidAt'];
  }

  if(C\contains_key($datas, 'dueAt')) {
    $this->dueAt = (string)$datas['dueAt'];
  }

  $this->netAmount = to_dict($datas['netAmount']) |> Amount::assert($$);
  $this->vatAmount = to_dict($datas['vatAmount']) |> Amount::assert($$);
  $this->grossAmount = to_dict($datas['grossAmount']) |> Amount::assert($$);

  $this->lines = vec[];
  $lines = $datas['lines'];
  if($lines is Traversable<_>) {
    foreach($lines as $line) {
    $this->lines[] = to_dict($line) |> Line::assert($$);
    }
  }

  $this->links = to_dict($datas['_links']) |> Links::assert($$);
  }
}
