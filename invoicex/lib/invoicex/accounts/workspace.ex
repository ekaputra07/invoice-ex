defmodule Invoicex.Accounts.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  # when we use it as route params it use the :uuid as key
  # Routes.account_path(conn, :show_workspace, workspace)
  @derive {Phoenix.Param, key: :uuid}

  schema "workspaces" do
    field(:uuid, Ecto.UUID)

    has_many(:invoices, Invoicex.Invoices.Invoice)
    has_many(:emails, Invoicex.Emails.Email)

    timestamps()
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
    |> unique_constraint(:uuid)
  end
end
