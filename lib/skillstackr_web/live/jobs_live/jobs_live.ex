defmodule SkillstackrWeb.JobsLive do
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "Job Experience")

    {:ok, socket}
  end
end
