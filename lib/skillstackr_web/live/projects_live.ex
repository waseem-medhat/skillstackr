defmodule SkillstackrWeb.ProjectsLive do
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Projects")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.page_heading page_title={@page_title} />

    <.info_box
      heading="All your projects are listed here."
      body="Any project can be added to one or more profiles."
    />

    <p class="mt-5 italic opacity-60">No projects yet.</p>

    <.link navigate={~p"/projects/new"}>
      <.button class="mt-5">
        <.icon name="hero-plus-mini" /> Add Project
      </.button>
    </.link>
    """
  end
end
