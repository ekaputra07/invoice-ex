defmodule Invoicex.Emails.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field(:email, :string)
    field(:verified, :boolean, default: false)

    belongs_to(:workspace, Invoicex.Accounts.Workspace)

    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
