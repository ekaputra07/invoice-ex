defmodule InvoicexWeb.PageController do
  use InvoicexWeb, :controller

  alias Invoicex.Invoices.TemplateServer

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def templates(conn, _params) do
    render(conn, "templates.html", templates: TemplateServer.list())
  end
end
