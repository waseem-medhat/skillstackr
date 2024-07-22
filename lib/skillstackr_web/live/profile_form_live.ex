defmodule SkillstackrWeb.ProfileFormLive do
  alias Skillstackr.Technologies
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.TechnologyComponents

  def mount(_params, _session, %{assigns: %{live_action: :new}} = socket) do
    {:ok, assign_with_data(socket, %Profile{}, Technologies.list_to_map([]))}
  end

  def mount(%{"slug" => slug} = _params, _session, %{assigns: %{live_action: :edit}} = socket) do
    case Profiles.get_profile_by_slug(slug) do
      nil ->
        {:ok, socket |> put_flash(:error, "Profile doesn't exist") |> redirect(to: ~p"/")}

      profile ->
        tech_map =
          profile.profiles_technologies
          |> Enum.map(& &1.technology)
          |> Technologies.list_to_map()

        {:ok, assign_with_data(socket, profile, tech_map)}
    end
  end

  defp assign_with_data(socket, profile, tech_map) do
    socket
    |> assign(:page_title, "Create Profile")
    |> assign(:profile, profile)
    |> assign(:form, to_form(Profiles.change_profile(profile)))
    |> assign(:tech_map, tech_map)
    |> assign(:tech_search_results, [])
    |> allow_upload(:resume, accept: ~w(.pdf))
  end

  def handle_event("search-technologies", params, socket) do
    results =
      case params["search-technologies"] do
        "" -> []
        str -> get_tech_names(str)
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
    profile_params =
      params
      |> Map.get("profile")
      |> Map.put("resume", get_resume_blob(socket))
      |> Map.put("account_id", socket.assigns.current_account.id)

    assoc_technologies = Technologies.map_to_list(socket.assigns.tech_map)

    case Profiles.create_profile(profile_params, assoc_technologies) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile saved. Start adding some projects to it!")
         |> redirect(to: ~p"/profiles/#{profile_params["slug"]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    profile_params =
      case get_resume_blob(socket) do
        nil -> params["profile"]
        blob -> Map.put(params["profile"], "resume", blob)
      end

    existing_tech_list =
      socket.assigns.profile.profiles_technologies
      |> Enum.map(fn %{technology: %{name: name, category: category}} ->
        %{"name" => name, "category" => category}
      end)

    new_tech_list =
      socket.assigns.tech_map
      |> Technologies.map_to_list()
      |> Enum.filter(fn map -> map not in existing_tech_list end)

    removed_profile_technology_ids =
      socket.assigns.profile.profiles_technologies
      |> Enum.filter(fn %{technology: %{name: name, category: category}} ->
        name not in socket.assigns.tech_map[category]
      end)
      |> Enum.map(& &1.id)

    Profiles.update_profile(
      socket.assigns.profile,
      profile_params,
      removed_profile_technology_ids,
      new_tech_list
    )
    |> case do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile saved!")
         |> redirect(to: ~p"/profiles/#{profile_params["slug"]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", _params, socket) do
    case Profiles.delete_profile(socket.assigns.profile) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile deleted successfully!")
         |> redirect(to: "/profiles")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "An error occurred!")}
    end
  end

  defp get_resume_blob(socket) do
    case socket.assigns.uploads.resume.entries do
      [] ->
        nil

      _ ->
        [resume_blob] =
          consume_uploaded_entries(socket, :resume, fn %{path: path}, _entry ->
            resume_blob = File.read!(path)
            {:ok, resume_blob}
          end)

        %{"blob" => resume_blob}
    end
  end

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.page_heading page_title={@page_title} />
      <section class="grid grid-cols-2 gap-8">
        <.input field={@form[:full_name]} type="text" label="Full Name" />
        <.input field={@form[:slug]} type="text" label="Profile Slug" />
        <.input field={@form[:headline]} type="text" label="Headline" />
        <.input field={@form[:email]} type="email" label="Email" />
        <div class="col-span-2">
          <.input field={@form[:summary]} type="textarea" label="Professional Summary" />
        </div>
      </section>

      <h2 class="text-xl">Profile Links</h2>
      <section class="grid grid-cols-2 gap-8">
        <.input field={@form[:link_github]} type="text" label="GitHub" icon="simple-github" />
        <.input field={@form[:link_linkedin]} type="text" label="LinkedIn" icon="simple-linkedin" />
        <.input
          field={@form[:link_website]}
          type="text"
          label="Website/Blog"
          icon="hero-globe-alt-micro"
        />
        <div>
          <.label icon="simple-adobeacrobatreader">Resume</.label>
          <.live_file_input
            upload={@uploads.resume}
            required={@live_action == :new}
            class="mt-2 block w-full border border-gray-200 shadow-sm rounded-lg text-sm focus:z-10 focus:border-primary focus:ring-primary disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-900 dark:border-neutral-700 dark:text-neutral-400 file:bg-gray-50 file:border-0 file:me-4 file:py-3 file:px-4 dark:file:bg-neutral-700 dark:file:text-neutral-400"
          />
        </div>
      </section>

      <hr class="dark:border-gray-800" />

      <h2 class="text-xl">Technologies</h2>

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
          This will permanently delete the profile but <i>not</i> associated projects. Proceed?
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
