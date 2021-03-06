defmodule InvoicexWeb.Mailer do
  use Phoenix.Swoosh,
    view: InvoicexWeb.MailerView,
    layout: {InvoicexWeb.LayoutView, :mailer}

  alias Invoicex.Mailer
  alias Invoicex.Invoices.Invoice
  alias Invoicex.Emails.Email

  defp mailer_from do
    Application.fetch_env!(:invoicex, :mailer_from)
  end

  def send_invoice(%Invoice{} = invoice, pdf_path) do
    from = mailer_from()

    Enum.each(invoice.emails, fn e ->
      new()
      |> from(from)
      |> to(e.email)
      |> subject("[SendMeInvoice] Your invoice is ready!")
      |> render_body("invoice.html", %{invoice: invoice})
      |> attachment(pdf_path)
      |> Mailer.deliver()
    end)
  end

  def send_invoice_error(%Invoice{} = invoice, attempt) do
    from = mailer_from()
    {current_attempt, max_attempts} = attempt

    Enum.each(invoice.emails, fn e ->
      new()
      |> from(from)
      |> to(e.email)
      |> subject("[SendMeInvoice] Error generating your invoice (attempt #{current_attempt})")
      |> render_body("invoice_error.html", %{
        invoice: invoice,
        current_attempt: current_attempt,
        max_attempts: max_attempts
      })
      |> Mailer.deliver()
    end)
  end

  def send_email_verification_link(conn, %Email{} = email) do
    token = conn |> Invoicex.Emails.generate_verification_token(email)
    endpoint = conn |> Phoenix.Controller.endpoint_module()

    new()
    |> from(mailer_from())
    |> to(email.email)
    |> subject("[SendMeInvoice] Verify email address")
    |> render_body("email_verification_link.html", %{
      endpoint: endpoint,
      email: email,
      token: token
    })
    |> Mailer.deliver()
  end
end
