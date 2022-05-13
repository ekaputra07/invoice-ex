defmodule InvoicexWeb.Plugs.BrandName do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn |> assign(:brand_name, Application.fetch_env!(:invoicex, :brand_name))
  end
end
