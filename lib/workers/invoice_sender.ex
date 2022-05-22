defmodule Invoicex.Workers.InvoiceSender do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias Invoicex.Invoices

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: 1}) do
    id
    |> get_active_invoice()
    |> case do
      nil ->
        :ok

      invoice ->
        # next schedule
        if invoice.repeat do
          {:ok, date} = Invoices.next_run_date(invoice)
          Invoices.schedule_invoice(invoice, worker: [scheduled_at: date])
        end

        # generate invoice pdf and send via email
        create_and_send_pdf_invoice(invoice, {1, 3})
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: attempt}) do
    id
    |> get_active_invoice()
    |> case do
      nil -> :ok
      invoice -> create_and_send_pdf_invoice(invoice, {attempt, 3})
    end
  end

  defp get_active_invoice(id) do
    with %Invoices.Invoice{} = invoice <- Invoices.get_invoice(id),
         true <- invoice.active do
      invoice
    else
      _ -> nil
    end
  end

  def get_pdf_file(%Invoices.Invoice{} = invoice) do
    with {:ok, file_url} <- Invoices.get_pdf_url(invoice),
         {:ok, file_path} <- Invoices.get_pdf_file(invoice, file_url),
         true <- File.exists?(file_path) do
      {:ok, file_path}
    else
      _ -> {:error, "Error while generating PDF invoice."}
    end
  end

  def create_and_send_pdf_invoice(%Invoices.Invoice{} = invoice, attempt) do
    with {:ok, pdf_path} <- get_pdf_file(invoice),
         :ok <- InvoicexWeb.Mailer.send_invoice(invoice, pdf_path) do
      File.rm(pdf_path)
      :ok
    else
      error ->
        InvoicexWeb.Mailer.send_invoice_error(invoice, attempt)
        {:error, error}
    end
  end
end
