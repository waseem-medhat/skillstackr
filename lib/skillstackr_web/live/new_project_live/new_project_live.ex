defmodule SkillstackrWeb.NewProjectLive do
  use SkillstackrWeb, :live_view
  
  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "New Project")

    {:ok, socket}
  end
end
