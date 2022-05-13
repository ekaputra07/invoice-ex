defmodule Invoicex.Repo.Migrations.AddRepeatInvoices do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add(:repeat, :boolean, default: false, null: false)
    end
  end
end
