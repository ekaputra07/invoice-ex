defmodule InvoicexWeb.Plugs.LoginRequired do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    case conn.assigns.current_workspace do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Unauthorized access.")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      _ ->
        conn
    end
  end
end
