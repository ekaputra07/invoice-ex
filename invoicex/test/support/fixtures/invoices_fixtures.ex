defmodule Invoicex.InvoicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicex.Invoices` context.
  """

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        active: true,
        body: "some body",
        name: "some name",
        schedule: "some schedule"
      })
      |> Invoicex.Invoices.create_invoice()

    invoice
  end
end
