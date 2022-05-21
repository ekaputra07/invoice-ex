defmodule Invoicex.Workers.InvoiceTestSender do
  use Oban.Worker, queue: :transactional, max_attempts: 2
  alias Invoicex.Invoices
  alias Invoicex.Workers.InvoiceSender

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: attempt}) do
    id
    |> Invoices.get_invoice()
    |> case do
      nil -> :ok
      invoice -> InvoiceSender.create_and_send_pdf_invoice(invoice, {attempt, 2})
    end
  end
end
