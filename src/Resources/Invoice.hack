namespace Mollie\Api\Resources;

use type Mollie\Api\Types\InvoiceStatus;

class Invoice extends BaseResource {
  public string $resource;

  public string $id;

  public string $reference;

  public string $vatNumber;

  public InvoiceStatus $status;

  /**
   * Date the invoice was issued, e.g. 2018-01-01
   */
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
   *
   * @var \stdClass
   * TODO
   */
  public mixed $netAmount;

  /**
   * Amount object containing the VAT amount of the invoice. Only for merchants registered in the Netherlands.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $vatAmount;

  /**
   * Total amount of the invoice including VAT.
   *
   * @var \stdClass
   * TODO
   */
  public mixed $grossAmount;

  /**
   * Object containing the invoice lines.
   * See https://docs.mollie.com/reference/v2/invoices-api/get-invoice for reference
   *
   * @var \stdClass
   * TODO
   */
  public mixed $lines;

  /**
   * Contains a PDF to the Invoice
   */
  public Links $links;

  public function isPaid(): bool {
    return $this->status == InvoiceStatus::STATUS_PAID;
  }

  public function isOpen(): bool {
    return $this->status == InvoiceStatus::STATUS_OPEN;
  }

  public function isOverdue(): bool {
    return $this->status == InvoiceStatus::STATUS_OVERDUE;
  }
}
