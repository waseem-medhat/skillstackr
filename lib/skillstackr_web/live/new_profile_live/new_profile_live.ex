defmodule SkillstackrWeb.NewProfileLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Profile")
      |> assign(:changeset, Profiles.change_profile(%Profile{}))
      |> assign(:technologies, TechnologyComponents.get_names())

    {:ok, socket}
  end
end
