defmodule SkillstackrWeb.AccountConfirmationInstructionsLiveTest do
  use SkillstackrWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Skillstackr.AccountsFixtures

  alias Skillstackr.Accounts
  alias Skillstackr.Repo

  setup do
    %{account: account_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/accounts/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, account: account} do
      {:ok, lv, _html} = live(conn, ~p"/accounts/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", account: %{email: account.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Accounts.AccountToken, account_id: account.id).context == "confirm"
    end

    test "does not send confirmation token if account is confirmed", %{
      conn: conn,
      account: account
    } do
      Repo.update!(Accounts.Account.confirm_changeset(account))

      {:ok, lv, _html} = live(conn, ~p"/accounts/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", account: %{email: account.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Accounts.AccountToken, account_id: account.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/accounts/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", account: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Accounts.AccountToken) == []
    end
  end
end
