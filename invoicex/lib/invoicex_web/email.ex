defmodule InvoicexWeb.Email do
  use Phoenix.Swoosh,
    view: InvoicexWeb.EmailView,
    layout: {InvoicexWeb.LayoutView, :email}

  alias Invoicex.Mailer
  alias Invoicex.Invoices.Invoice

  def send_invoice(%Invoice{} = invoice, pdf_path) do
    new()
    |> from("noreply@upkoding.com")
    |> to("ekaputra07@gmail.com")
    |> subject("[InvoiceMator] Your invoice is ready!")
    |> render_body("welcome.html", %{invoice: invoice})
    |> attachment(pdf_path)
    |> Mailer.deliver()
  end
end
