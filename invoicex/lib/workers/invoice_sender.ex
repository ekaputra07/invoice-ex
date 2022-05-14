defmodule Invoicex.Workers.InvoiceSender do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias Invoicex.Invoices

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: 1}) do
    invoice = Invoices.get_invoice!(id)

    case invoice.active do
      true ->
        # next schedule
        next_run_date = Invoices.next_run_date(invoice)

        invoice.repeat && next_run_date &&
          Invoices.schedule_invoice(invoice, worker: [scheduled_at: next_run_date])

        create_and_send_pdf_invoice(invoice)

      false ->
        :ok
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    invoice = Invoices.get_invoice!(id)

    case invoice.active do
      true -> create_and_send_pdf_invoice(invoice)
      false -> :ok
    end
  end

  def create_and_send_pdf_invoice(%Invoices.Invoice{} = invoice) do
    with {:ok, file_url} <- Invoices.get_pdf_url(invoice),
         {:ok, file_path} <- Invoices.get_pdf_file(invoice, file_url),
         true <- File.exists?(file_path),
         {:ok, _} <- InvoicexWeb.Email.send_invoice(invoice, file_path),
         :ok <- File.rm(file_path) do
      :ok
    else
      error ->
        error
    end
  end
end
