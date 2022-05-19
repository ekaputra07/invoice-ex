defmodule Invoicex.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field(:active, :boolean, default: false)
    field(:repeat, :boolean, default: false)
    field(:body, :string)
    field(:name, :string)
    field(:schedule, :string)

    belongs_to(:workspace, Invoicex.Accounts.Workspace)

    many_to_many(:emails, Invoicex.Emails.Email,
      join_through: "invoice_emails",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:name, :body, :active, :repeat, :schedule])
    |> validate_required([:name, :body, :active, :repeat, :schedule])
  end
end
