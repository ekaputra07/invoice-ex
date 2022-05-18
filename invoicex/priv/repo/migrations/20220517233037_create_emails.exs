defmodule Invoicex.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add(:email, :string)
      add(:verified, :boolean, default: false, null: false)
      add(:workspace_id, references(:workspaces, on_delete: :delete_all))

      timestamps()
    end

    create(index(:emails, [:workspace_id]))
    create(unique_index(:emails, [:workspace_id, :email]))
  end
end
