defmodule InvoicexWeb.InvoiceView do
  use InvoicexWeb, :view
  alias Invoicex.Invoices
  alias Invoicex.Emails
  alias Invoicex.Utils.Mustache

  def render_body(body) do
    Mustache.render(body)
  end

  def checkbox_options(%Plug.Conn{} = conn, form, changeset) do
    current_email_ids =
      changeset
      |> Ecto.Changeset.get_change(:emails, [])
      |> Enum.map(& &1.data.id)

    for email <- Emails.list_verified_emails(conn.assigns.current_workspace) do
      %{label: email.email, value: email.id, checked: email.id in current_email_ids}
    end
  end
end
