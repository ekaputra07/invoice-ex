defmodule Invoicex.EmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicex.Emails` context.
  """

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        email: "some email",
        verified: true
      })
      |> Invoicex.Emails.create_email()

    email
  end
end
