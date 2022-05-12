defmodule InvoicexWeb.Router do
  use InvoicexWeb, :router

  @doc """
  Provide :brand_name accross the site.
  """
  def brand_name(conn, _) do
    conn |> assign(:brand_name, Application.fetch_env!(:invoicex, :brand_name))
  end

  @doc """
  Provide current workspace object accross the site.
  """
  def current_workspace(conn, _) do
    ws = get_session(conn, :current_workspace)
    conn |> assign(:current_workspace, ws)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {InvoicexWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:brand_name)
    plug(:current_workspace)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", InvoicexWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/workspace", InvoicexWeb do
    pipe_through(:browser)

    post("/create", AccountController, :create_workspace)
    post("/check", AccountController, :check_workspace)
    get("/access", AccountController, :access_workspace)
    get("/logout", AccountController, :exit_workspace)
    get("/manage", AccountController, :manage_workspace)
  end

  scope "/invoices", InvoicexWeb do
    pipe_through(:browser)

    resources("/", InvoiceController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", InvoicexWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: InvoicexWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
