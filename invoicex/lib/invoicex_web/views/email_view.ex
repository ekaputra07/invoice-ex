defmodule InvoicexWeb.EmailView do
  use InvoicexWeb, :view

  def token(conn, email) do
    Invoicex.Emails.generate_verification_token(conn, email)
  end
end
