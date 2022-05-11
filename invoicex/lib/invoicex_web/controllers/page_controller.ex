defmodule InvoicexWeb.PageController do
  use InvoicexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
