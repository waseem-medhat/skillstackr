defmodule SkillstackrWeb.ProjectFormLive do
  alias Skillstackr.{Accounts, Projects, Technologies}
  alias Skillstackr.Projects.Project
  alias Skillstackr.Technologies.Technology
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.TechnologyComponents

  def mount(_params, _session, %{assigns: %{live_action: :new}} = socket) do
    {:ok, assign_with_data(socket, %Project{profiles_projects: []}, Technologies.list_to_map([]))}
  end

  def mount(%{"id" => id}, _session, %{assigns: %{live_action: :edit}} = socket) do
    case Projects.get_project(id) do
      nil ->
        {:ok, socket |> put_flash(:error, "Project doesn't exist") |> redirect(to: ~p"/projects")}

      project ->
        tech_map =
          project.projects_technologies
          |> Enum.map(& &1.technology)
          |> Technologies.list_to_map()

        {:ok, assign_with_data(socket, project, tech_map)}
    end
  end

  defp assign_with_data(socket, project, tech_map) do
    socket
    |> assign(:page_title, "Add Project")
    |> assign(:project, project)
    |> assign(:form, to_form(Projects.change_project(project)))
    |> assign(:account_profiles, Accounts.get_account_profiles!(socket.assigns.current_account))
    |> assign(:tech_map, tech_map)
    |> assign(:tech_search_results, [])
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

  def handle_event("remove-technology-" <> category, params, socket) do
    selected = params["value"]

    new_category_technologies =
      socket.assigns.tech_map
      |> Map.get(category)
      |> List.delete(selected)

    new_tech_map = Map.put(socket.assigns.tech_map, category, new_category_technologies)
    {:noreply, assign(socket, :tech_map, new_tech_map)}
  end

  def handle_event("save", params, %{assigns: %{live_action: :new}} = socket) do
    assoc_profile_ids =
      socket.assigns.account_profiles
      |> Enum.filter(fn acc_p -> params[acc_p.slug] === "true" end)
      |> Enum.map(& &1.id)

    project_params =
      params["project"]
      |> Map.put("account_id", socket.assigns.current_account.id)

    assoc_technologies = Technologies.map_to_list(socket.assigns.tech_map)

    case Projects.create_project(project_params, assoc_profile_ids, assoc_technologies) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project added")
         |> redirect(to: ~p"/projects")}

      {:error, :project, changeset, _} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    %{
      tech_map: new_tech_map,
      account_profiles: account_profiles,
      project: %{
        projects_technologies: current_projects_technologies,
        profiles_projects: current_profiles_projects
      }
    } = socket.assigns

    new_assoc_profile_ids =
      account_profiles
      |> Enum.filter(fn acc_p -> params[acc_p.slug] === "true" end)
      |> Enum.map(& &1.id)

    current_assoc_profile_ids =
      current_profiles_projects
      |> Enum.map(& &1.profile.id)

    assoc_profile_id_insertions = new_assoc_profile_ids -- current_assoc_profile_ids
    assoc_profile_id_deletions = current_assoc_profile_ids -- new_assoc_profile_ids

    profile_project_id_deletions =
      current_profiles_projects
      |> Enum.filter(fn pj -> pj.profile.id in assoc_profile_id_deletions end)
      |> Enum.map(& &1.id)

    project_technology_id_deletions =
      current_projects_technologies
      |> Enum.filter(fn %{technology: %Technology{name: tech_name, category: category}} ->
        tech_name not in new_tech_map[category]
      end)
      |> Enum.map(& &1.id)

    assoc_technologies = Technologies.map_to_list(new_tech_map)

    Projects.update_project(
      socket.assigns.project,
      params["project"],
      project_technology_id_deletions,
      assoc_technologies,
      profile_project_id_deletions,
      assoc_profile_id_insertions
    )
    |> case do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project saved.")
         |> redirect(to: ~p"/projects")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", _params, socket) do
    case Projects.delete_project(socket.assigns.project) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project deleted successfully!")
         |> redirect(to: "/projects")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "An error occurred!")}
    end
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
          <div :for={tech <- @tech_map["frontend"]} class="relative">
            <button
              type="button"
              phx-click="remove-technology-frontend"
              value={tech}
              class="text-red-500 hover:text-red-400 cursor-pointer opacity-70"
            >
              <.icon name="hero-x-mark-micro" class="absolute top-[-10px] right-[-10px]" />
            </button>
            <.tech_badge tech={tech} class="pointer-events-none" />
          </div>
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Back-end</span>
          <div :for={tech <- @tech_map["backend"]} class="relative">
            <button
              type="button"
              phx-click="remove-technology-backend"
              value={tech}
              class="text-red-500 hover:text-red-400 cursor-pointer opacity-70"
            >
              <.icon name="hero-x-mark-micro" class="absolute top-[-10px] right-[-10px]" />
            </button>
            <.tech_badge tech={tech} class="pointer-events-none" />
          </div>
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">DevOps</span>
          <div :for={tech <- @tech_map["devops"]} class="relative">
            <button
              type="button"
              phx-click="remove-technology-devops"
              value={tech}
              class="text-red-500 hover:text-red-400 cursor-pointer opacity-70"
            >
              <.icon name="hero-x-mark-micro" class="absolute top-[-10px] right-[-10px]" />
            </button>
            <.tech_badge tech={tech} class="pointer-events-none" />
          </div>
        </div>

        <div class="flex items-center gap-2 h-12">
          <span class="w-20 font-light">Dev tools</span>
          <div :for={tech <- @tech_map["devtools"]} class="relative">
            <button
              type="button"
              phx-click="remove-technology-devtools"
              value={tech}
              class="text-red-500 hover:text-red-400 cursor-pointer opacity-70"
            >
              <.icon name="hero-x-mark-micro" class="absolute top-[-10px] right-[-10px]" />
            </button>
            <.tech_badge tech={tech} class="pointer-events-none" />
          </div>
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

    <section :if={@live_action == :edit} class="pb-36">
      <hr class="dark:border-gray-800 my-8" />

      <.button
        id="delete-button"
        style="outline-red"
        phx-click={
          JS.remove_class("hidden", to: "#confirm-prompt")
          |> JS.add_class("hidden", to: "#delete-button")
        }
      >
        Delete Profile
      </.button>

      <div id="confirm-prompt" class="hidden">
        <p class="my-6">
          This will permanently delete the project and remove its association
          from all profiles. Proceed?
        </p>

        <.button
          style="outline"
          phx-click={
            JS.add_class("hidden", to: "#confirm-prompt")
            |> JS.remove_class("hidden", to: "#delete-button")
          }
        >
          Cancel
        </.button>

        <.button phx-click="delete" style="outline-red">Confirm and Delete</.button>
      </div>
    </section>
    """
  end
end
