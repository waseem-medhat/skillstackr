defmodule SkillstackrWeb.ProfileShowLive do
  alias Skillstackr.Technologies
  alias Skillstackr.Profiles
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.ProfileComponents
  import SkillstackrWeb.TechnologyComponents

  def mount(%{"slug" => slug} = _params, _session, socket) do
    case Profiles.get_profile_by_slug(slug) do
      nil ->
        {:ok, socket |> put_flash(:error, "Profile doesn't exist") |> redirect(to: ~p"/")}

      profile ->
        {:ok, assign_with_data(socket, profile)}
    end
  end

  defp assign_with_data(socket, profile) do
    editable =
      case socket.assigns.current_account do
        nil ->
          nil

        acc ->
          acc
          |> Accounts.get_account_slugs!()
          |> Enum.find_value(&(&1 == profile.slug))
      end

    socket
    |> assign(:page_title, profile.full_name)
    |> assign(:profile, profile)
    |> assign(:editable, editable)
    |> assign(
      :tech_map,
      profile.profiles_technologies
      |> Enum.map(& &1.technology)
      |> Technologies.list_to_map()
    )
  end

  def render(assigns) do
    ~H"""
    <div id="profile-header" class="flex flex-col md:flex-row items-center gap-5 mb-8">
      <img
        class="inline-block size-20 aspect-square rounded-full"
        src={~p"/profiles/#{@profile.slug}/photo.jpg"}
        alt="Image Description"
      />

      <hgroup class="flex-grow class flex flex-col items-center md:items-start">
        <h1 class="text-4xl font-bold mb-1"><%= @profile.full_name %></h1>
        <h2 class="text-xl font-semibold"><%= @profile.headline %></h2>
      </hgroup>

      <div id="profile-links" class="flex gap-2">
        <.profile_link
          :if={@profile.link_github}
          url={@profile.link_github}
          icon_name="simple-github"
        />
        <.profile_link
          :if={@profile.link_linkedin}
          url={@profile.link_linkedin}
          icon_name="simple-linkedin"
        />
        <.profile_link
          :if={@profile.link_website}
          url={@profile.link_website}
          icon_name="hero-globe-alt"
        />
        <.profile_link
          url={~p"/profiles/#{@profile.slug}/resume.pdf"}
          icon_name="simple-adobeacrobatreader"
        />
        <.profile_link
          :if={@profile.email}
          url={"mailto:#{@profile.email}"}
          icon_name="hero-at-symbol"
        />
      </div>

      <%= if @editable do %>
        <.link navigate={~p"/profiles/#{@profile.slug}/edit"}>
          <.button>
            <.icon name="hero-pencil-square-mini" /> Edit
          </.button>
        </.link>
      <% end %>
    </div>

    <section id="professional-summary" class="mb-5">
      <p id="summary-text">
        <%= @profile.summary %>
      </p>
    </section>

    <section id="skills" class="grid grid-cols-1 md:grid-cols-2 gap-3">
      <div :if={length(@tech_map["frontend"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">Front-end</span>
        <.tech_badge :for={tech <- @tech_map["frontend"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["backend"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">Back-end</span>
        <.tech_badge :for={tech <- @tech_map["backend"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["devops"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">DevOps</span>
        <.tech_badge :for={tech <- @tech_map["devops"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["devtools"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">Dev tools</span>
        <.tech_badge :for={tech <- @tech_map["devtools"]} tech={tech} />
      </div>
    </section>

    <section id="professional-experience" class="my-5">
      <h2 class="text-xl font-bold mb-3">Projects</h2>
      <.project_grid
        projects={Enum.map(@profile.profiles_projects, & &1.project)}
        editable={@editable}
      />
    </section>

    <section id="professional-experience" class="my-5">
      <div class="flex items-center justify-between">
        <h2 class="text-xl font-bold mb-3">Professional Experience</h2>
        <p>
          <%= @profile.profiles_jobs |> Enum.map(& &1.job.experience_years) |> Enum.sum() %> Years
        </p>
      </div>
      <.job_accordion jobs={Enum.map(@profile.profiles_jobs, & &1.job)} editable={@editable} />
    </section>
    """
  end
end
