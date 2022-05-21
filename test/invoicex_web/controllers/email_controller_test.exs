defmodule InvoicexWeb.EmailControllerTest do
  use InvoicexWeb.ConnCase

  import Invoicex.EmailsFixtures

  @create_attrs %{email: "some email", verified: true}
  @update_attrs %{email: "some updated email", verified: false}
  @invalid_attrs %{email: nil, verified: nil}

  describe "index" do
    test "lists all emails", %{conn: conn} do
      conn = get(conn, Routes.email_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Emails"
    end
  end

  describe "new email" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.email_path(conn, :new))
      assert html_response(conn, 200) =~ "New Email"
    end
  end

  describe "create email" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :create), email: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.email_path(conn, :show, id)

      conn = get(conn, Routes.email_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Email"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :create), email: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Email"
    end
  end

  describe "edit email" do
    setup [:create_email]

    test "renders form for editing chosen email", %{conn: conn, email: email} do
      conn = get(conn, Routes.email_path(conn, :edit, email))
      assert html_response(conn, 200) =~ "Edit Email"
    end
  end

  describe "update email" do
    setup [:create_email]

    test "redirects when data is valid", %{conn: conn, email: email} do
      conn = put(conn, Routes.email_path(conn, :update, email), email: @update_attrs)
      assert redirected_to(conn) == Routes.email_path(conn, :show, email)

      conn = get(conn, Routes.email_path(conn, :show, email))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, email: email} do
      conn = put(conn, Routes.email_path(conn, :update, email), email: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Email"
    end
  end

  describe "delete email" do
    setup [:create_email]

    test "deletes chosen email", %{conn: conn, email: email} do
      conn = delete(conn, Routes.email_path(conn, :delete, email))
      assert redirected_to(conn) == Routes.email_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.email_path(conn, :show, email))
      end
    end
  end

  defp create_email(_) do
    email = email_fixture()
    %{email: email}
  end
end
