defmodule SkillstackrWeb.NewProfileLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Profile")
      |> assign(:changeset, Profiles.change_profile(%Profile{}))
      |> assign(:technologies, [])

    {:ok, socket}
  end

  def handle_event("search-technologies", params, socket) do
    results =
      case params["search-technologies"] do
        "" -> []
        str -> TechnologyComponents.get_names(str)
      end

    {:noreply, assign(socket, :technologies, results)}
  end
end
