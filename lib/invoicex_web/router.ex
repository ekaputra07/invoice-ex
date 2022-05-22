defmodule InvoicexWeb.Router do
  use InvoicexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {InvoicexWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(InvoicexWeb.Plugs.BrandName)
    plug(InvoicexWeb.Plugs.CurrentWorkspace)
  end

  pipeline :authenticated do
    plug(InvoicexWeb.Plugs.LoginRequired)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", InvoicexWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # worksoace
  scope "/", InvoicexWeb do
    pipe_through(:browser)

    scope "/account" do
      post("/create", AccountController, :create_workspace)
      post("/check", AccountController, :check_workspace)
      get("/access", AccountController, :access_workspace)
    end

    scope "/account" do
      pipe_through(:authenticated)

      get("/logout", AccountController, :exit_workspace)
      post("/delete", AccountController, :delete_workspace)
      get("/", AccountController, :manage_workspace)
    end
  end

  # invoices
  scope "/invoices", InvoicexWeb do
    pipe_through([:browser, :authenticated])

    resources("/", InvoiceController, except: [:show])
    get("/:id/preview", InvoiceController, :preview)
    post("/:id/sending_test", InvoiceController, :sending_test)
    post("/:id/toggle_active", InvoiceController, :toggle_active)
    post("/:id/toggle_recurring", InvoiceController, :toggle_recurring)
  end

  # emails
  scope "/", InvoicexWeb do
    pipe_through(:browser)

    scope "/emails" do
      get("/verify/status", EmailController, :verification_status)
      get("/verify/:token", EmailController, :verify_email)
    end

    scope "/emails" do
      pipe_through(:authenticated)

      resources("/", EmailController, except: [:show, :edit, :update])
      post("/:id/send_verification_email", EmailController, :send_verification_email)
    end
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
