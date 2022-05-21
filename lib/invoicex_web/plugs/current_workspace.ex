defmodule InvoicexWeb.Plugs.CurrentWorkspace do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    ws = get_session(conn, :current_workspace)
    conn |> assign(:current_workspace, ws)
  end
end
