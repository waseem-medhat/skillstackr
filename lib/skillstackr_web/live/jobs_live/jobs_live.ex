defmodule SkillstackrWeb.JobsLive do
  alias Skillstackr.Jobs
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:jobs, Jobs.list_jobs())
      |> assign(:page_title, "Job Experience")

    {:ok, socket}
  end
end
