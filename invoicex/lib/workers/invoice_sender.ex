defmodule Invoicex.Workers.InvoiceSender do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias Invoicex.Invoices

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}, attempt: 1}) do
    invoice = Invoices.get_invoice!(id)

    if invoice.active do
      # next schedule
      next_run_date = Invoices.next_run_date(invoice)

      invoice.repeat && next_run_date &&
        Invoices.schedule_invoice(invoice, worker: [scheduled_at: next_run_date])

      # do heavy work
      invoice |> InvoicexWeb.Email.send_invoice("")
    end

    :ok
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    invoice = Invoices.get_invoice!(id)
    invoice.active && invoice |> InvoicexWeb.Email.send_invoice("")
    :ok
  end
end
