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

  def send_verification_email(conn, %{"id" => id}) do
    email = Emails.get_email!(conn.assigns.current_workspace, id)

    conn
    |> InvoicexWeb.Mailer.send_email_verification_link(email)
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Verification link sent to #{email.email}")
        |> redirect(to: Routes.email_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Sorry! we're having issue sending verification email.")
        |> redirect(to: Routes.email_path(conn, :index))
    end
  end

  def verify_email(conn, %{"token" => token}) do
    conn
    |> put_flash(:info, "Email verified!")
    |> redirect(to: Routes.email_path(conn, :verification_status))
  end

  def verification_status(conn, _params), do: render(conn, "verification_status.html")
end
