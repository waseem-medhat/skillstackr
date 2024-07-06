defmodule SkillstackrWeb.ProjectsLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Projects")
      |> assign(:projects, Accounts.get_account_projects(socket.assigns.current_account))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.page_heading page_title={@page_title} />

    <.info_box
      heading="All your projects are listed here."
      body="Any project can be added to one or more profiles."
    />

    <.link navigate={~p"/projects/new"}>
      <.button class="mt-5">
        <.icon name="hero-plus-mini" /> Add Project
      </.button>
    </.link>

    <i :if={length(@projects) == 0} class="block opacity-50 my-5">No projects</i>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 my-5">
      <div
        :for={p <- @projects}
        class="relative bg-white dark:bg-slate-950/70 rounded-lg shadow-lg p-5 transition"
      >
        <h1 class="text-xl font-bold"><%= p.title %></h1>

        <%= if p.description do %>
          <p class="text-sm text-gray-500 dark:text-neutral-400 flex-grow">
            <%= p.description %>
          </p>
        <% else %>
          <i class="text-sm text-gray-400 dark:text-neutral-700 flex-grow">
            No description
          </i>
        <% end %>

        <section class="mt-5">
          <div class="flex gap-2">
            <TechnologyComponents.tech_badge
              :for={t <- p.projects_technologies}
              tech={t.technology.name}
              size={18}
            />
          </div>
        </section>
      </div>
    </div>
    """
  end
end
