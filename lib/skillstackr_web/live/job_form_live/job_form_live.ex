defmodule SkillstackrWeb.JobFormLive do
  use SkillstackrWeb, :live_view
  
  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "New Job")

    {:ok, socket}
  end
end
