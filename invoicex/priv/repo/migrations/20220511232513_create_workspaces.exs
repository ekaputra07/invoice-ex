defmodule Invoicex.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add(:uuid, :uuid)

      timestamps()
    end

    create(unique_index(:workspaces, [:uuid]))
  end
end
