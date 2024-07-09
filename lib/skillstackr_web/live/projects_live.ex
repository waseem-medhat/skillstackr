defmodule SkillstackrWeb.ProjectsLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.ProfileComponents

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
      <.project_card :for={p <- @projects} project={p} editable={true} />
    </div>
    """
  end
end
