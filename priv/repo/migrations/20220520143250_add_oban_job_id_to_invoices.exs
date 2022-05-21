defmodule Invoicex.Repo.Migrations.AddObanJobIdToInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add(:oban_job_id, :integer, default: 0, null: false)
    end
  end
end
