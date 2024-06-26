defmodule SkillstackrWeb.ProjectFormLive do
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Add Project")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.page_heading page_title={@page_title} />
    """
  end
end
