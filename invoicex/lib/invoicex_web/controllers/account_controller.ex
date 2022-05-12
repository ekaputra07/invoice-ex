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
          "New workspace has been created with ID=#{workspace.uuid}. Important: don't loose this ID, you'll need this to access your invoices."
        )
        |> redirect(to: Routes.account_path(conn, :show_workspace, workspace))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error creating workspace!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def show_workspace(conn, %{"uuid" => workspace_id}) do
    with {:ok, uuid} <- Ecto.UUID.cast(workspace_id),
         %Workspace{} = workspace <- Accounts.get_workspace(uuid) do
      render(conn, "show_workspace.html", workspace: workspace)
    else
      _ ->
        conn
        |> put_flash(:error, "Workspace not found!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
