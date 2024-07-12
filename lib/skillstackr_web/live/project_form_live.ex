defmodule SkillstackrWeb.ProjectFormLive do
  alias Skillstackr.{Accounts, Projects, Technologies}
  alias Skillstackr.Projects.Project
  alias Skillstackr.ProjectsTechnologies.ProjectTechnology
  alias Skillstackr.Technologies.Technology
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.TechnologyComponents

  def mount(params, _session, socket) do
    {project, tech_map} =
      case socket.assigns.live_action do
        :new ->
          {%Project{profiles_projects: []}, Technologies.list_to_map([])}

        :edit ->
          project = Projects.get_project!(params["id"])

          tech_map =
            project.projects_technologies
            |> Enum.map(& &1.technology)
            |> Technologies.list_to_map()

          {project, tech_map}
      end

    socket =
      socket
      |> assign(:page_title, "Add Project")
      |> assign(:project, project)
      |> assign(:form, to_form(Projects.change_project(project)))
      |> assign(:account_profiles, Accounts.get_account_profiles!(socket.assigns.current_account))
      |> assign(:tech_map, tech_map)
      |> assign(:tech_search_results, [])

    {:ok, socket}
  end

  def handle_event("search-technologies", params, socket) do
    results =
      case params["search-technologies"] do
        "" -> []
        str -> get_tech_names(str)
      end

    {:noreply, assign(socket, :tech_search_results, results)}
  end

  def handle_event("toggle-technology-" <> category, params, socket) do
    selected = params["value"]
    category_technologies = Map.get(socket.assigns.tech_map, category)

    new_category_technologies =
      case selected in category_technologies do
        false -> [selected | category_technologies]
        true -> List.delete(category_technologies, selected)
      end

    new_tech_map = Map.put(socket.assigns.tech_map, category, new_category_technologies)
    {:noreply, assign(socket, :tech_map, new_tech_map)}
  end

  def handle_event("save", params, %{assigns: %{live_action: :new}} = socket) do
    assoc_profiles =
      socket.assigns.account_profiles
      |> Enum.filter(fn acc_p -> params[acc_p.slug] === "true" end)

    project_params =
      params["project"]
      |> Map.put("account_id", socket.assigns.current_account.id)

    assoc_technologies = Technologies.map_to_list(socket.assigns.tech_map)

    case Projects.create_project(project_params, assoc_profiles, assoc_technologies) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project added")
         |> redirect(to: ~p"/projects")}

      {:error, :new_project, changeset, _} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    current_projects_technologies = socket.assigns.project.projects_technologies

    {proj_tech_id_deletions, tech_insertion_param_list} =
      diff_technologies(current_projects_technologies, socket.assigns.tech_map)

    Projects.update_project(
      socket.assigns.project,
      params["project"],
      proj_tech_id_deletions,
      tech_insertion_param_list
    )
    |> case do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "project saved!")
         |> redirect(to: ~p"/projects")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp diff_technologies(current_projects_technologies, new_tech_map) do
    proj_tech_id_deletions =
      current_projects_technologies
      |> Enum.filter(fn %{technology: %Technology{name: tech_name, category: category}} ->
        tech_name not in new_tech_map[category]
      end)
      |> Enum.map(& &1.id)

    current_tech_list =
      current_projects_technologies
      |> Enum.map(fn %{technology: %{name: name, category: category}} ->
        %{"name" => name, "category" => category}
      end)

    tech_insertion_param_list =
      new_tech_map
      |> Technologies.map_to_list()
      |> Enum.filter(fn map -> map not in current_tech_list end)

    {proj_tech_id_deletions, tech_insertion_param_list}
  end

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-submit="save">
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
          <.tech_badge :for={tech <- @tech_map["frontend"]} tech={tech} class="pointer-events-none" />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Back-end</span>
          <.tech_badge :for={tech <- @tech_map["backend"]} tech={tech} class="pointer-events-none" />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">DevOps</span>
          <.tech_badge :for={tech <- @tech_map["devops"]} tech={tech} class="pointer-events-none" />
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Dev tools</span>
          <.tech_badge :for={tech <- @tech_map["devtools"]} tech={tech} class="pointer-events-none" />
        </div>
      </section>

      <.search_box tech_search_results={@tech_search_results} />

      <section>
        <.label>Add to Profiles</.label>
        <ul class="my-2 space-y-1">
          <.input
            :for={acc_p <- @account_profiles}
            type="checkbox"
            label={acc_p.slug}
            name={acc_p.slug}
            checked={acc_p.slug in Enum.map(@project.profiles_projects, & &1.profile.slug)}
          />
        </ul>
      </section>

      <:actions>
        <.button type="submit">Save Profile</.button>
      </:actions>
    </.simple_form>
    """
  end
end
