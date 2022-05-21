defmodule Invoicex.Repo do
  use Ecto.Repo,
    otp_app: :invoicex,
    adapter: Ecto.Adapters.Postgres
end
