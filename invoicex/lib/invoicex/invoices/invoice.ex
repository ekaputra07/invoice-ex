defmodule Invoicex.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :active, :boolean, default: false
    field :body, :string
    field :name, :string
    field :schedule, :string

    belongs_to :workspace, Invoicex.Accounts.Workspace

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:name, :body, :active, :schedule])
    |> validate_required([:name, :body, :active, :schedule])
  end
end
