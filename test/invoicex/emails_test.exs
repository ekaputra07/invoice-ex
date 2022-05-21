defmodule Invoicex.EmailsTest do
  use Invoicex.DataCase

  alias Invoicex.Emails

  describe "emails" do
    alias Invoicex.Emails.Email

    import Invoicex.EmailsFixtures

    @invalid_attrs %{email: nil, verified: nil}

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Emails.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Emails.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      valid_attrs = %{email: "some email", verified: true}

      assert {:ok, %Email{} = email} = Emails.create_email(valid_attrs)
      assert email.email == "some email"
      assert email.verified == true
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Emails.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      update_attrs = %{email: "some updated email", verified: false}

      assert {:ok, %Email{} = email} = Emails.update_email(email, update_attrs)
      assert email.email == "some updated email"
      assert email.verified == false
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Emails.update_email(email, @invalid_attrs)
      assert email == Emails.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Emails.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Emails.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Emails.change_email(email)
    end
  end
end
