defmodule Invoicex.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Query, warn: false
  alias Invoicex.Repo

  alias Invoicex.Accounts.Workspace
  alias Invoicex.Invoices.Invoice

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices(workspace) do
    Repo.all(
      from(i in Invoice,
        where: i.workspace_id == ^workspace.id
      )
    )
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(workspace, id) do
    Invoice
    |> Repo.get_by!(workspace_id: workspace.id, id: id)
    |> Repo.preload(:workspace)

    # Invoice
    # |> Repo.get!(id)
    # |> Repo.preload(:workspace)
  end

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> change_invoice(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> change_invoice(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    # workspace can't be changed after set
    workspace =
      case invoice.workspace do
        # on update
        %Workspace{} -> invoice.workspace
        # on create
        _ -> attrs["workspace"]
      end

    invoice
    |> Repo.preload(:workspace)
    |> Invoice.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:workspace, workspace)
  end
end
