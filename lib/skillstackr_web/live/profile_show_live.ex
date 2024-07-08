defmodule SkillstackrWeb.ProfileShowLive do
  alias Skillstackr.Technologies
  alias Skillstackr.Profiles
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view

  def mount(%{"slug" => slug} = _params, _session, socket) do
    %{profile: profile, technologies: technologies, jobs: jobs, projects: projects} =
      Profiles.get_profile_by_slug!(slug)

    editable =
      case socket.assigns.current_account do
        nil ->
          nil

        acc ->
          acc
          |> Accounts.get_account_slugs!()
          |> Enum.find_value(&(&1 == slug))
      end

    socket =
      socket
      |> assign(:page_title, profile.full_name)
      |> assign(:profile, profile)
      |> assign(:editable, editable)
      |> assign(:tech_map, Technologies.list_to_map(technologies))
      |> assign(:jobs, jobs)
      |> assign(:total_exp_years, jobs |> Enum.map(& &1.years_of_experience) |> Enum.sum())
      |> assign(:projects, projects)

    {:ok, socket}
  end

  def project_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-white border shadow-sm rounded-xl dark:bg-slate-950/90 dark:border-neutral-700 dark:shadow-neutral-700/70">
      <img
        class="w-full h-auto rounded-t-xl"
        src={~p"/images/project-placeholder.png"}
        alt={@project.project.title}
      />
      <div class="p-4 md:p-5 space-y-4">
        <header>
          <h3 class="text-lg font-bold text-gray-800 dark:text-white">
            <%= @project.project.title %>
          </h3>
          <div class="flex gap-2 mt-1 mb-2">
            <TechnologyComponents.tech_badge
              :for={tech <- @project.technologies}
              tech={tech.name}
              size={16}
            />
          </div>
        </header>
        <p class="text-gray-500 dark:text-neutral-400">
          <%= @project.project.description %>
        </p>
        <footer class="text-indigo-700">
          <.link navigate={@project.project.link_repo} class="hover:text-indigo-500">
            Code
          </.link>
          <span class="text-gray-400 dark:text-gray-600 font-light mx-1">|</span>
          <.link navigate={@project.project.link_website} class="hover:text-indigo-500">
            Website
          </.link>
        </footer>
      </div>
    </div>
    """
  end

  def job_accordion(assigns) do
    ~H"""
    <div class="hs-accordion-group">
      <div
        :for={job <- @jobs}
        class="hs-accordion bg-white border -mt-px first:rounded-t-lg last:rounded-b-lg dark:bg-slate-950/90 dark:border-neutral-700"
        id={"hs-bordered-heading-#{job.id}"}
      >
        <button
          class="hs-accordion-toggle hs-accordion-active:text-indigo-600 inline-flex items-center justify-between gap-x-3 w-full font-semibold text-start text-gray-800 py-4 px-5 hover:text-gray-500 disabled:opacity-50 disabled:pointer-events-none dark:hs-accordion-active:text-indigo-600 dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:outline-none dark:focus:text-neutral-400"
          aria-controls={"hs-basic-bordered-collapse-#{job.id}"}
        >
          <div class="flex items-center gap-2">
            <svg
              class="hs-accordion-active:hidden block size-4"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="m6 9 6 6 6-6"></path>
            </svg>
            <svg
              class="hs-accordion-active:block hidden size-4"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="m18 15-6-6-6 6"></path>
            </svg>
            <h3><%= job.title %></h3>
          </div>
          <p class="text-sm font-medium text-right">
            <%= job.experience_years %> years @ <%= job.company %>
          </p>
        </button>
        <div
          id={"hs-basic-bordered-collapse-#{job.id}"}
          class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300"
          aria-labelledby={"hs-bordered-heading-#{job.id}"}
        >
          <div class="pb-4 px-5">
            <p class="text-gray-800 dark:text-neutral-200">
              <%= job.description %>
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def profile_link(assigns) do
    ~H"""
    <a
      href={@url}
      class="flex items-center gap-2 opacity-70 hover:opacity-100 transition-all duration-200"
      target="_blank"
    >
      <.icon name={@icon_name} size={20} />
    </a>
    """
  end

  def render(assigns) do
    ~H"""
    <div id="profile-header" class="flex flex-col md:flex-row items-center gap-5 mb-8">
      <img
        class="inline-block size-20 aspect-square rounded-full contrast-0"
        src={~p"/images/profile-icon.png"}
        alt="Image Description"
      />

      <hgroup class="flex-grow class flex flex-col items-center md:items-start">
        <h1 class="text-4xl font-bold mb-1"><%= @profile.full_name %></h1>
        <h2 class="text-xl font-semibold"><%= @profile.headline %></h2>
      </hgroup>

      <div id="profile-links" class="flex gap-3">
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
        <TechnologyComponents.tech_badge :for={tech <- @tech_map["frontend"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["backend"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">Back-end</span>
        <TechnologyComponents.tech_badge :for={tech <- @tech_map["backend"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["devops"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">DevOps</span>
        <TechnologyComponents.tech_badge :for={tech <- @tech_map["devops"]} tech={tech} />
      </div>

      <div :if={length(@tech_map["devtools"]) > 0} class="flex items-center gap-2">
        <span class="w-20 font-light">Dev tools</span>
        <TechnologyComponents.tech_badge :for={tech <- @tech_map["devtools"]} tech={tech} />
      </div>
    </section>

    <section id="professional-experience" class="my-5">
      <h2 class="text-xl font-bold mb-3">Projects</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
        <.project_card :for={project <- @projects} project={project} />
      </div>
    </section>

    <section id="professional-experience" class="my-5">
      <div class="flex items-center justify-between">
        <h2 class="text-xl font-bold mb-3">Professional Experience</h2>
        <p>
          <%= @total_exp_years %> Years
        </p>
      </div>
      <.job_accordion jobs={@jobs} />
    </section>
    """
  end
end
