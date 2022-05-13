defmodule Invoicex.Workers.InvoiceTestSender do
  use Oban.Worker, queue: :transactional, max_attempts: 3
  alias Invoicex.Invoices

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: attempt}) do
    IO.inspect("Attemp #{attempt}")

    invoice = Invoices.get_invoice!(id)

    {:ok, file_url} = invoice |> Invoices.get_pdf()
    InvoicexWeb.Email.send_invoice(invoice, file_url)

    :ok
  end
end
