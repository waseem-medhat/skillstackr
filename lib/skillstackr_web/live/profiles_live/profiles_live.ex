defmodule SkillstackrWeb.ProfilesLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    profiles = socket.assigns.current_account
    |> Accounts.get_account_profiles!()

    socket =
      socket
      |> assign(:page_title, "Profiles")
      |> assign(:profiles, profiles)

    {:ok, socket}
  end
end
