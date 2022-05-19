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
  def get_invoice!(id) do
    Invoice
    |> Repo.get!(id)
    |> Repo.preload([:workspace, :emails])
  end

  def get_invoice!(workspace, id) do
    Invoice
    |> Repo.get_by!(workspace_id: workspace.id, id: id)
    |> Repo.preload([:workspace, :emails])
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
    IO.inspect(attrs)

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

    emails = Invoicex.Emails.list_emails_by_ids(workspace, attrs["emails"])

    invoice
    |> Invoice.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:workspace, workspace)
    |> Ecto.Changeset.put_assoc(:emails, emails)
  end

  def get_pdf_url(%Invoice{} = invoice) do
    Invoicex.Utils.PDF.html_to_pdf(
      Invoicex.Utils.Mustache.render(invoice.body),
      Application.fetch_env!(:invoicex, :api2pdf_api_key)
    )
  end

  def get_pdf_file(%Invoice{} = invoice, pdf_url) do
    uuid = Ecto.UUID.generate()

    # simple effort to cleanup the name
    file_name =
      invoice.name
      |> String.downcase()
      |> String.replace(" ", "-")
      |> Kernel.<>(".pdf")

    pdf_path = "/tmp/invoicex/pdfs/#{uuid}/#{file_name}"

    case Invoicex.Utils.File.download(pdf_url, pdf_path) do
      {:ok, _} -> {:ok, pdf_path}
      error -> error
    end
  end

  def next_run_date(%Invoice{} = invoice) do
    with true <- invoice.active,
         {:ok, cron} <- Crontab.CronExpression.Parser.parse(invoice.schedule),
         {:ok, date} <- Crontab.Scheduler.get_next_run_date(cron) do
      date
    else
      _ -> nil
    end
  end

  def schedule_invoice(%Invoice{} = invoice, options \\ []) do
    %{id: invoice.id, options: Enum.into(options[:job] || [], %{})}
    |> Invoicex.Workers.InvoiceSender.new(options[:worker])
    |> Oban.insert()
  end

  def schedule_test_invoice(%Invoice{} = invoice, options \\ []) do
    %{id: invoice.id, options: Enum.into(options, %{})}
    |> Invoicex.Workers.InvoiceTestSender.new()
    |> Oban.insert()
  end
end
