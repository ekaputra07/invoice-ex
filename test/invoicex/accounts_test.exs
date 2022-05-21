defmodule Invoicex.AccountsTest do
  use Invoicex.DataCase

  alias Invoicex.Accounts

  describe "workspaces" do
    alias Invoicex.Accounts.Workspace

    import Invoicex.AccountsFixtures

    @invalid_attrs %{uuid: nil}

    test "list_workspaces/0 returns all workspaces" do
      workspace = workspace_fixture()
      assert Accounts.list_workspaces() == [workspace]
    end

    test "get_workspace!/1 returns the workspace with given id" do
      workspace = workspace_fixture()
      assert Accounts.get_workspace!(workspace.id) == workspace
    end

    test "create_workspace/1 with valid data creates a workspace" do
      valid_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Workspace{} = workspace} = Accounts.create_workspace(valid_attrs)
      assert workspace.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_workspace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_workspace(@invalid_attrs)
    end

    test "update_workspace/2 with valid data updates the workspace" do
      workspace = workspace_fixture()
      update_attrs = %{uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Workspace{} = workspace} = Accounts.update_workspace(workspace, update_attrs)
      assert workspace.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_workspace/2 with invalid data returns error changeset" do
      workspace = workspace_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_workspace(workspace, @invalid_attrs)
      assert workspace == Accounts.get_workspace!(workspace.id)
    end

    test "delete_workspace/1 deletes the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{}} = Accounts.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_workspace!(workspace.id) end
    end

    test "change_workspace/1 returns a workspace changeset" do
      workspace = workspace_fixture()
      assert %Ecto.Changeset{} = Accounts.change_workspace(workspace)
    end
  end
end
