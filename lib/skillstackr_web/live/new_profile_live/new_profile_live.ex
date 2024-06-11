defmodule SkillstackrWeb.NewProfileLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Profile")
      |> assign(:trigger_submit, false)
      |> assign(:form, to_form(Profiles.change_profile(%Profile{})))
      |> assign(:technologies, %{
        "frontend" => [],
        "backend" => [],
        "devops" => [],
        "devtools" => []
      })
      |> assign(:tech_search_results, [])

    {:ok, socket}
  end

  def handle_event("search-technologies", params, socket) do
    results =
      case params["search-technologies"] do
        "" -> []
        str -> TechnologyComponents.get_names(str)
      end

    {:noreply, assign(socket, :tech_search_results, results)}
  end

  def handle_event("validate", params, socket) do
    new_form =
      Profiles.change_profile(%Profile{}, params["profile"])
      |> Map.put(:action, :validate)
      |> to_form(as: "profile")

    {:noreply, assign(socket, form: new_form)}
  end

  def handle_event("toggle-technology-" <> category, params, socket) do
    current_technologies = Map.get(socket.assigns.technologies, category)
    selected = params["value"]

    new_technologies =
      case Enum.find(current_technologies, &(&1 == selected)) do
        nil -> [selected | current_technologies]
        ^selected -> Enum.filter(current_technologies, &(&1 != selected))
      end

    {:noreply,
     assign(socket, :technologies, Map.put(socket.assigns.technologies, category, new_technologies))}
  end
end
