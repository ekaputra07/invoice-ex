defmodule Invoicex.InvoicesTest do
  use Invoicex.DataCase

  alias Invoicex.Invoices

  describe "invoices" do
    alias Invoicex.Invoices.Invoice

    import Invoicex.InvoicesFixtures

    @invalid_attrs %{active: nil, body: nil, name: nil, schedule: nil}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Invoices.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoices.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{
        active: true,
        body: "some body",
        name: "some name",
        schedule: "some schedule"
      }

      assert {:ok, %Invoice{} = invoice} = Invoices.create_invoice(valid_attrs)
      assert invoice.active == true
      assert invoice.body == "some body"
      assert invoice.name == "some name"
      assert invoice.schedule == "some schedule"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()

      update_attrs = %{
        active: false,
        body: "some updated body",
        name: "some updated name",
        schedule: "some updated schedule"
      }

      assert {:ok, %Invoice{} = invoice} = Invoices.update_invoice(invoice, update_attrs)
      assert invoice.active == false
      assert invoice.body == "some updated body"
      assert invoice.name == "some updated name"
      assert invoice.schedule == "some updated schedule"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoices.update_invoice(invoice, @invalid_attrs)
      assert invoice == Invoices.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoices.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoices.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Invoices.change_invoice(invoice)
    end
  end
end
