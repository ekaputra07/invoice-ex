defmodule Invoicex.Assocs.InvoiceEmail do
  use Ecto.Schema

  schema "invoice_emails" do
    field(:invoice_id, :integer)
    field(:email_id, :integer)
  end
end
