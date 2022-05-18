defmodule InvoicexWeb.Mailer do
  use Phoenix.Swoosh,
    view: InvoicexWeb.MailerView,
    layout: {InvoicexWeb.LayoutView, :mailer}

  alias Invoicex.Mailer
  alias Invoicex.Invoices.Invoice
  alias Invoicex.Emails.Email

  def send_invoice(%Invoice{} = invoice, pdf_path) do
    new()
    |> from("noreply@upkoding.com")
    |> to("ekaputra07@gmail.com")
    |> subject("[SendMeInvoice] Your invoice is ready!")
    |> render_body("invoice.html", %{invoice: invoice})
    |> attachment(pdf_path)
    |> Mailer.deliver()
  end

  def send_email_verification_link(conn, %Email{} = email) do
    token = conn |> Invoicex.Emails.generate_verification_token(email)
    endpoint = conn |> Phoenix.Controller.endpoint_module()

    new()
    |> from("noreply@upkoding.com")
    |> to("ekaputra07@gmail.com")
    |> subject("[SendMeInvoice] Verify email address")
    |> render_body("email_verification_link.html", %{
      endpoint: endpoint,
      email: email,
      token: token
    })
    |> Mailer.deliver()
  end
end
