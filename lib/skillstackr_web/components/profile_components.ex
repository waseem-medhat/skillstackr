defmodule SkillstackrWeb.ProfileComponents do
  @moduledoc """
  Profile-related components. They are used both in the profile "show" page and
  in the listing pages ("/projects", "/jobs").
  """
  use SkillstackrWeb, :verified_routes
  use Phoenix.Component
  import SkillstackrWeb.CoreComponents
  import SkillstackrWeb.TechnologyComponents

  attr :projects, :any, required: true
  attr :editable, :boolean, default: false

  def project_grid(assigns) do
    ~H"""
    <div
      class="grid grid-cols-1 md:grid-cols-2 gap-5 my-5"
      id="project-grid"
      phx-hook="ReloadPrelineTooltip"
    >
      <div
        :for={p <- @projects}
        class="flex flex-col bg-white border shadow rounded-xl dark:bg-slate-950/90 dark:border-neutral-700 dark:shadow-neutral-700/70"
      >
        <img
          class="w-full h-auto rounded-t-xl"
          src={~p"/images/project-placeholder.png"}
          alt={p.title}
        />
        <div class="p-4 md:p-5 relative">
          <div :if={@editable} class="absolute top-6 right-6 flex gap-2 items-center">
            <.link
              navigate={~p"/projects/#{p.id}/edit"}
              class="bg-indigo-700 text-white rounded-lg p-1.5 inline-flex items-center hover:bg-indigo-500 z-10 text-sm gap-1"
            >
              <.icon name="hero-pencil-square-micro" />
            </.link>
          </div>

          <header>
            <h3 class="text-lg font-bold text-gray-800 dark:text-white">
              <%= p.title %>
            </h3>
            <div class="flex gap-2 mt-1 mb-2">
              <.tech_badge
                :for={tech <- Enum.map(p.projects_technologies, & &1.technology)}
                tech={tech.name}
                size={16}
              />
            </div>
          </header>

          <p class="text-gray-500 dark:text-neutral-400 my-4">
            <%= p.description %>
          </p>

          <footer class="text-indigo-700">
            <.link navigate={p.link_repo} class="hover:text-indigo-500">
              Code
            </.link>
            <span class="text-gray-400 dark:text-gray-600 font-light mx-1">|</span>
            <.link navigate={p.link_website} class="hover:text-indigo-500">
              Website
            </.link>
          </footer>
        </div>
      </div>
    </div>
    """
  end

  attr :jobs, :any, required: true
  attr :editable, :boolean, default: false

  def job_accordion(assigns) do
    ~H"""
    <div class="hs-accordion-group" id="accordion" phx-hook="ReloadPrelineAccordion">
      <div
        :for={job <- @jobs}
        class="hs-accordion bg-white border -mt-px first:rounded-t-lg last:rounded-b-lg dark:bg-slate-950/90 dark:border-neutral-700 shadow"
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
          <p class="text-sm font-medium flex items-center gap-2">
            <%= job.experience_years %> years @ <%= job.company %>
            <.link
              :if={@editable}
              navigate={~p"/jobs/#{job.id}/edit"}
              class="bg-indigo-700 text-white rounded-lg p-1.5 inline-flex items-center hover:bg-indigo-500 z-10 text-sm gap-1"
            >
              <.icon name="hero-pencil-square-micro" />
            </.link>
          </p>
        </button>
        <div
          id={"hs-basic-bordered-collapse-#{job.id}"}
          class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300"
          aria-labelledby={"hs-bordered-heading-#{job.id}"}
        >
          <div class="pb-4 px-5">
            <%= if job.description do %>
              <p class="text-sm text-gray-500 dark:text-neutral-400 flex-grow">
                <%= job.description %>
              </p>
            <% else %>
              <i class="text-gray-400 dark:text-neutral-700 flex-grow">
                No description
              </i>
            <% end %>
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
end
