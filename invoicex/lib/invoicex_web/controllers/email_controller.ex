defmodule InvoicexWeb.EmailController do
  use InvoicexWeb, :controller

  alias Invoicex.Emails
  alias Invoicex.Emails.Email

  def index(conn, _params) do
    emails = Emails.list_emails(conn.assigns.current_workspace)
    render(conn, "index.html", emails: emails)
  end

  def new(conn, _params) do
    changeset = Emails.change_email(%Email{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"email" => email_params}) do
    case Emails.create_email(Map.put(email_params, "workspace", conn.assigns.current_workspace)) do
      {:ok, email} ->
        conn
        |> put_flash(:info, "#{email.email} created successfully.")
        |> redirect(to: Routes.email_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    email = Emails.get_email!(conn.assigns.current_workspace, id)
    {:ok, _email} = Emails.delete_email(email)

    conn
    |> put_flash(:info, "#{email.email} deleted successfully.")
    |> redirect(to: Routes.email_path(conn, :index))
  end
end
