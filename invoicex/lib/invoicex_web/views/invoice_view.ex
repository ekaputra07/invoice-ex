defmodule InvoicexWeb.InvoiceView do
  use InvoicexWeb, :view
  alias Invoicex.Invoices
  alias Invoicex.Utils.Mustache

  def render_body(body) do
    Mustache.render(body)
  end
end
