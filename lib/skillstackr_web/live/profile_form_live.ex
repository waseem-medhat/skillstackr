defmodule SkillstackrWeb.ProfileFormLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view

  def mount(params, _session, socket) do
    profile =
      case socket.assigns.live_action do
        :edit -> Profiles.get_profile_by_slug!(params["id"]).profile
        :new -> %Profile{}
      end

    tech_list = []

    technologies =
      Enum.reduce(
        tech_list,
        %{"frontend" => [], "backend" => [], "devops" => [], "devtools" => []},
        fn %{name: name, category: category}, acc_map ->
          Map.put(acc_map, category, [name | acc_map[category]])
        end
      )

    socket =
      socket
      |> assign(:page_title, "Create Profile")
      |> assign(:profile, profile)
      |> assign(:form, to_form(Profiles.change_profile(profile)))
      |> assign(:technologies, technologies)
      |> assign(:tech_search_results, [])
      |> allow_upload(:resume, accept: ~w(.pdf))

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
     assign(
       socket,
       :technologies,
       Map.put(socket.assigns.technologies, category, new_technologies)
     )}
  end

  def handle_event("save", params, %{assigns: %{live_action: :new}} = socket) do
    profile_params =
      params
      |> Map.get("profile")
      |> Map.put("resume", get_resume_blob(socket))
      |> Map.put("account_id", socket.assigns.current_account.id)

    assoc_technologies = get_technologies(socket)

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
      params
      |> Map.get("profile")
      |> Map.put("technologies", get_technologies(socket))
      |> Map.put("account_id", socket.assigns.current_account.id)

    profile_params =
      case get_resume_blob(socket) do
        nil -> profile_params
        blob -> Map.put(profile_params, "resume", blob)
      end

    case Profiles.update_profile(socket.assigns.profile, profile_params) do
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

  defp get_technologies(socket) do
    socket.assigns.technologies
    |> Enum.flat_map(fn {category, tech_list} ->
      Enum.map(tech_list, &%{"name" => &1, "category" => category})
    end)
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
            class="mt-2 block w-full border border-gray-200 shadow-sm rounded-lg text-sm focus:z-10 focus:border-indigo-700 focus:ring-indigo-700 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-900 dark:border-neutral-700 dark:text-neutral-400 file:bg-gray-50 file:border-0 file:me-4 file:py-3 file:px-4 dark:file:bg-neutral-700 dark:file:text-neutral-400"
          />
        </div>
      </section>

      <hr class="dark:border-gray-800" />

      <h2 class="text-xl">Technologies</h2>

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
