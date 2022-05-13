defmodule Invoicex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Invoicex.Repo,
      # Start the Telemetry supervisor
      InvoicexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Invoicex.PubSub},
      # Start the Endpoint (http/https)
      InvoicexWeb.Endpoint,
      # Oban
      {Oban, Application.fetch_env!(:invoicex, Oban)}
      # Start a worker by calling: Invoicex.Worker.start_link(arg)
      # {Invoicex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Invoicex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvoicexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
