defmodule Invoicex.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :name, :string
      add :body, :text
      add :active, :boolean, default: false, null: false
      add :schedule, :string
      add :workspace_id, references(:workspaces, on_delete: :delete_all)

      timestamps()
    end

    create index(:invoices, [:workspace_id])
    create index(:invoices, [:active])
  end
end
