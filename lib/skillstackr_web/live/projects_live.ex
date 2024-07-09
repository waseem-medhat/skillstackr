defmodule SkillstackrWeb.ProjectsLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.TechnologyComponents

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

        <div class="text-sm text-gray-500 dark:text-neutral-400 flex-grow mt-2 mb-5">
          <%= if p.description do %>
            <p><%= p.description %></p>
          <% else %>
            <i>No description</i>
          <% end %>
        </div>

        <div class="flex gap-2">
          <.tech_badge :for={t <- p.projects_technologies} tech={t.technology.name} size={18} />
        </div>

        <div class="absolute top-6 right-6 flex gap-2 items-center">
          <.link
            navigate={~p"/projects/#{p.id}/edit"}
            class="bg-indigo-700 text-white rounded-lg p-1.5 inline-flex items-center hover:bg-indigo-500 z-10 text-sm gap-1"
          >
            <.icon name="hero-pencil-square-micro" />
          </.link>
        </div>
      </div>
    </div>
    """
  end
end
