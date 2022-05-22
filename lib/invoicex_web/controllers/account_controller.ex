defmodule InvoicexWeb.AccountController do
  use InvoicexWeb, :controller
  alias Invoicex.Accounts
  alias Invoicex.Accounts.Workspace

  def create_workspace(conn, _params) do
    case Accounts.create_workspace() do
      {:ok, workspace} ->
        conn
        |> put_flash(
          :info,
          "An account created for you with key #{workspace.uuid} to manage your invoices. Please keep this key somewhere safe."
        )
        |> put_session(:current_workspace, workspace)
        |> redirect(to: Routes.account_path(conn, :manage_workspace))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error creating account!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def access_workspace(conn, _params) do
    current_workspace = get_session(conn, :current_workspace) || %Workspace{}
    changeset = Accounts.change_workspace(current_workspace)
    render(conn, "access_workspace.html", changeset: changeset)
  end

  def check_workspace(conn, %{"workspace" => workspace_params}) do
    with {:ok, value} <- Map.fetch(workspace_params, "uuid"),
         {:ok, uuid} <- Ecto.UUID.cast(value),
         %Workspace{} = workspace <- Accounts.get_workspace(uuid) do
      conn
      |> put_session(:current_workspace, workspace)
      |> redirect(to: Routes.invoice_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Account not found!")
        |> redirect(to: Routes.account_path(conn, :access_workspace))
    end
  end

  def manage_workspace(conn, _) do
    render(conn, "manage_workspace.html", workspace: conn.assigns.current_workspace)
  end

  def exit_workspace(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "You're logged-out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete_workspace(conn, _params) do
    case Accounts.delete_workspace(conn.assigns.current_workspace) do
      {:ok, _} ->
        conn
        |> clear_session()
        |> put_flash(:info, "You're account (invoices, emails) has been deleted.")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        conn
        |> put_flash(
          :error,
          "Oops! We're having trouble deleting your account, please contact us directly for manual deletion."
        )
        |> redirect(to: Routes.account_path(conn, :manage_workspace))
    end
  end
end
