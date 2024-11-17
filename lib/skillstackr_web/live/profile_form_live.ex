defmodule SkillstackrWeb.ProfileFormLive do
  use SkillstackrWeb, :live_view

  alias Skillstackr.Technologies
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  import SkillstackrWeb.ProfileComponents
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
    |> allow_upload(:profile_photo, accept: ~w(.png .jpg .jpeg))
  end

  def handle_event("search-technologies", params, socket) do
    results = find_tech_names(params["search-technologies"])
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
    profile_params =
      params
      |> Map.get("profile")
      |> Map.put("account_id", socket.assigns.current_account.id)

    assoc_technologies = Technologies.map_to_list(socket.assigns.tech_map)
    uploads = extract_uploads(socket)

    case Profiles.create_profile(profile_params, assoc_technologies, uploads) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile saved. Start adding some projects to it!")
         |> redirect(to: ~p"/profiles/#{profile_params["slug"]}")}

      {:error, :profile, %Ecto.Changeset{} = changeset, %{}} = _error ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    profile_params =
      case extract_uploads(socket) do
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

  defp extract_uploads(socket) do
    resume_blob_list =
      consume_uploaded_entries(socket, :resume, fn %{path: path}, _entry ->
        resume_blob = File.read!(path)
        {:ok, resume_blob}
      end)

    resume_blob =
      case resume_blob_list do
        [] -> nil
        [blob] -> blob
      end

    photo_blob_list =
      consume_uploaded_entries(socket, :profile_photo, fn %{path: path}, _entry ->
        photo_blob = File.read!(path)
        {:ok, photo_blob}
      end)

    photo_blob =
      case photo_blob_list do
        [] -> nil
        [blob] -> blob
      end

    {resume_blob, photo_blob}
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
        <div class="flex gap-3">
          <div class="flex-grow">
            <.label>Profile Photo</.label>
            <.live_file_input
              upload={@uploads.profile_photo}
              class="mt-2 block w-full border border-gray-200 shadow-sm rounded-lg text-sm focus:z-10 focus:border-primary focus:ring-primary disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-900 dark:border-neutral-700 dark:text-neutral-400 file:bg-gray-50 file:border-0 file:me-4 file:py-3 file:px-4 dark:file:bg-neutral-700 dark:file:text-neutral-400"
            />
          </div>
          <div class="size-20">
            <.profile_photo slug={@profile.slug} upload_entries={@uploads.profile_photo.entries} />
          </div>
        </div>
        <.input field={@form[:summary]} type="textarea" label="Professional Summary" />
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
            class="mt-2 block w-full border border-gray-200 shadow-sm rounded-lg text-sm focus:z-10 focus:border-primary focus:ring-primary disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-900 dark:border-neutral-700 dark:text-neutral-400 file:bg-gray-50 file:border-0 file:me-4 file:py-3 file:px-4 dark:file:bg-neutral-700 dark:file:text-neutral-400"
          />
        </div>
      </section>

      <hr class="dark:border-gray-800" />

      <h2 class="text-xl">Technologies</h2>

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
        Delete Project
      </.button>

      <div id="confirm-prompt" class="hidden">
        <p class="my-6">
          This will permanently delete the profile but <i>not</i> associated
          projects and job experience. Proceed?
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
