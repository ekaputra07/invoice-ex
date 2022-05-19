defmodule Invoicex.Repo.Migrations.CreateInvoiceEmails do
  use Ecto.Migration

  def change do
    create table(:invoice_emails, primary_key: false) do
      add(:invoice_id, references(:invoices, on_delete: :delete_all))
      add(:email_id, references(:emails, on_delete: :delete_all))
    end

    create(index(:invoice_emails, [:invoice_id]))
    create(index(:invoice_emails, [:email_id]))
    create(unique_index(:invoice_emails, [:invoice_id, :email_id]))
  end
end
