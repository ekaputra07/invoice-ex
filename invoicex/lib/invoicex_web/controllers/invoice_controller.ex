defmodule InvoicexWeb.InvoiceController do
  use InvoicexWeb, :controller

  alias Invoicex.Invoices
  alias Invoicex.Invoices.Invoice

  def index(conn, _params) do
    invoices = Invoices.list_invoices(conn.assigns.current_workspace)
    render(conn, "index.html", invoices: invoices)
  end

  def new(conn, _params) do
    changeset = Invoices.change_invoice(%Invoice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invoice" => invoice_params}) do
    case Invoices.create_invoice(
           # set workspace
           Map.put(invoice_params, "workspace", conn.assigns.current_workspace)
         ) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "#{invoice.name} created successfully.")
        |> redirect(to: Routes.invoice_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    case invoice.active do
      true ->
        conn
        |> put_flash(:error, "Can not edit running invoice! please deactivate first.")
        |> redirect(to: Routes.invoice_path(conn, :index))

      false ->
        changeset = Invoices.change_invoice(invoice)
        render(conn, "edit.html", invoice: invoice, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    case Invoices.update_invoice(invoice, invoice_params) do
      {:ok, invoice} ->
        conn
        |> put_flash(:info, "#{invoice.name} updated successfully.")
        |> redirect(to: Routes.invoice_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invoice: invoice, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    case invoice.active do
      true ->
        conn
        |> put_flash(:error, "Can not delete running invoice! please deactivate first.")
        |> redirect(to: Routes.invoice_path(conn, :index))

      false ->
        {:ok, _invoice} = Invoices.delete_invoice(invoice)

        conn
        |> put_flash(:info, "Invoice deleted successfully.")
        |> redirect(to: Routes.invoice_path(conn, :index))
    end
  end

  def toggle_active(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    new_status = !invoice.active

    if new_status && !Invoices.has_recipients?(invoice) do
      conn
      |> put_flash(:error, "Please add recipient(s) to #{invoice.name} invoice.")
      |> redirect(to: Routes.invoice_path(conn, :index))
    else
      case Invoices.set_active(invoice, new_status) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Active status for #{invoice.name} updated.")
          |> redirect(to: Routes.invoice_path(conn, :index))

        _ ->
          conn
          |> put_flash(:error, "Error updating active status for #{invoice.name}.")
          |> redirect(to: Routes.invoice_path(conn, :index))
      end
    end
  end

  def toggle_recurring(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    case Invoices.set_repeat(invoice, !invoice.repeat) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Recurring status for #{invoice.name} updated.")
        |> redirect(to: Routes.invoice_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Error updating recurring status for #{invoice.name}.")
        |> redirect(to: Routes.invoice_path(conn, :index))
    end
  end

  def preview(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)

    conn
    |> put_root_layout(false)
    |> put_layout(false)
    |> render("preview.html", invoice: invoice)
  end

  def sending_test(conn, %{"id" => id}) do
    invoice = Invoices.get_invoice!(conn.assigns.current_workspace, id)
    invoice |> Invoices.schedule_test_invoice()

    conn
    |> put_flash(:info, "Test email has been scheduled for #{invoice.name}.")
    |> redirect(to: Routes.invoice_path(conn, :index))
  end
end
