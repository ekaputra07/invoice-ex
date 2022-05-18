defmodule InvoicexWeb.Mailer do
  use Phoenix.Swoosh,
    view: InvoicexWeb.MailerView,
    layout: {InvoicexWeb.LayoutView, :mailer}

  alias Invoicex.Mailer
  alias Invoicex.Invoices.Invoice

  def send_invoice(%Invoice{} = invoice, pdf_path) do
    new()
    |> from("noreply@upkoding.com")
    |> to("ekaputra07@gmail.com")
    |> subject("[SendMeInvoice] Your invoice is ready!")
    |> render_body("invoice.html", %{invoice: invoice})
    |> attachment(pdf_path)
    |> Mailer.deliver()
  end
end
