defmodule SkillstackrWeb.ProjectFormLive do
  alias Skillstackr.Projects
  alias Skillstackr.Projects.Project
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    project =
      case socket.assigns.live_action do
        :new -> %Project{}
      end

    technologies = %{"frontend" => [], "backend" => [], "devops" => [], "devtools" => []}

    socket =
      socket
      |> assign(:page_title, "Add Project")
      |> assign(:form, to_form(Projects.change_project(project)))
      |> assign(:technologies, technologies)
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

  def handle_event("toggle-technology-" <> category, params, socket) do
    current_technologies = Map.get(socket.assigns.technologies, category)
    selected = params["value"]

    new_technologies =
      case Enum.find(current_technologies, &(&1 == selected)) do
        nil -> [selected | current_technologies]
        ^selected -> Enum.filter(current_technologies, &(&1 != selected))
      end

    {:noreply,
     assign(
       socket,
       :technologies,
       Map.put(socket.assigns.technologies, category, new_technologies)
     )}
  end

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.page_heading page_title={@page_title} />
      <section class="grid grid-cols-2 gap-8">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:link_repo]} type="text" label="Code URL" />
        <.input field={@form[:link_website]} type="text" label="Website URL" />
        <div class="col-span-2">
          <.input field={@form[:description]} type="textarea" label="Description" />
        </div>
      </section>

      <.label>Technologies</.label>
      <section id="skills" class="grid grid-cols-2 gap-3">
        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Front-end</span>
          <TechnologyComponents.tech_badge
            :for={tech <- @technologies["frontend"]}
            tech={tech}
            class="pointer-events-none"
          />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Back-end</span>
          <TechnologyComponents.tech_badge
            :for={tech <- @technologies["backend"]}
            tech={tech}
            class="pointer-events-none"
          />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">DevOps</span>
          <TechnologyComponents.tech_badge
            :for={tech <- @technologies["devops"]}
            tech={tech}
            class="pointer-events-none"
          />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Dev tools</span>
          <TechnologyComponents.tech_badge
            :for={tech <- @technologies["devtools"]}
            tech={tech}
            class="pointer-events-none"
          />
        </div>
      </section>
      <section>
        <.input
          type="search"
          name="search-technologies"
          id="search-technologies"
          placeholder="Start searching"
          phx-change="search-technologies"
          phx-debounce="300"
          value=""
        />

        <div class="h-36 overflow-y-auto my-2 p-2 border dark:border-neutral-700 border-gray-200 rounded-lg">
          <div class="flex items-center justify-center gap-1 flex-wrap">
            <TechnologyComponents.choice_button :for={tech <- @tech_search_results} tech={tech} />
          </div>
        </div>
      </section>

      <:actions>
        <.button type="submit">Save Profile</.button>
      </:actions>
    </.simple_form>
    """
  end
end
