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

    <p :if={length(@projects) == 0} class="mt-5 italic opacity-60">No projects yet.</p>

    <section>
      <div
        :for={p <- @projects}
        class="relative bg-white dark:bg-slate-950/70 rounded-lg my-5 shadow-lg p-5 transition"
      >
        <h1 class="text-xl font-bold"><%= p.title %></h1>
        <p><%= p.description %></p>
      </div>
    </section>

    <.link navigate={~p"/projects/new"}>
      <.button class="mt-5">
        <.icon name="hero-plus-mini" /> Add Project
      </.button>
    </.link>
    """
  end
end
