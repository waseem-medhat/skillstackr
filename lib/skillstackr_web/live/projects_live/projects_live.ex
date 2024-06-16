defmodule SkillstackrWeb.ProjectsLive do
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "Projects")

    {:ok, socket}
  end
end
