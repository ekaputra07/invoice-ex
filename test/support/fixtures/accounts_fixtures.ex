defmodule Invoicex.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicex.Accounts` context.
  """

  @doc """
  Generate a unique workspace uuid.
  """
  def unique_workspace_uuid do
    raise "implement the logic to generate a unique workspace uuid"
  end

  @doc """
  Generate a workspace.
  """
  def workspace_fixture(attrs \\ %{}) do
    {:ok, workspace} =
      attrs
      |> Enum.into(%{
        uuid: unique_workspace_uuid()
      })
      |> Invoicex.Accounts.create_workspace()

    workspace
  end
end
