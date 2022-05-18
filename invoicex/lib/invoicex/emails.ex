defmodule Invoicex.Emails do
  @moduledoc """
  The Emails context.
  """

  import Ecto.Query, warn: false
  alias Invoicex.Repo

  alias Invoicex.Accounts.Workspace
  alias Invoicex.Emails.Email

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails(workspace) do
    Repo.all(from(e in Email, where: e.workspace_id == ^workspace.id))
    |> Repo.preload(:workspace)
  end

  def list_emails() do
    Repo.all(Email)
  end

  @doc """
  Gets a single email.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(workspace, id) do
    Email
    |> Repo.get_by(workspace_id: workspace.id, id: id)
    |> Repo.preload(:workspace)
  end

  @doc """
  Creates a email.

  ## Examples

      iex> create_email(%{field: value})
      {:ok, %Email{}}

      iex> create_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(attrs \\ %{}) do
    %Email{}
    |> change_email(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a email.

  ## Examples

      iex> update_email(email, %{field: new_value})
      {:ok, %Email{}}

      iex> update_email(email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email(%Email{} = email, attrs) do
    email
    |> change_email(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a email.

  ## Examples

      iex> delete_email(email)
      {:ok, %Email{}}

      iex> delete_email(email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email changes.

  ## Examples

      iex> change_email(email)
      %Ecto.Changeset{data: %Email{}}

  """
  def change_email(%Email{} = email, attrs \\ %{}) do
    # workspace can't be changed after set
    workspace =
      case email.workspace do
        # on update
        %Workspace{} -> email.workspace
        # on create
        _ -> attrs["workspace"]
      end

    email
    |> Repo.preload(:workspace)
    |> Email.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:workspace, workspace)
  end

  def generate_verification_token(conn, %Email{} = email, max_age \\ 86400) do
    Phoenix.Token.sign(conn, email.workspace.uuid, email.id, max_age: max_age)
  end
end