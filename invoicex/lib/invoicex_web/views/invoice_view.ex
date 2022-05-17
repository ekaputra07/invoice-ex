defmodule InvoicexWeb.InvoiceView do
  use InvoicexWeb, :view
  alias Invoicex.Invoices
  alias Invoicex.Utils.Mustache

  def yes_no(value) do
    if value do
      "YES"
    else
      "NO"
    end
  end

  def render_body(body) do
    Mustache.render(body)
  end
end
