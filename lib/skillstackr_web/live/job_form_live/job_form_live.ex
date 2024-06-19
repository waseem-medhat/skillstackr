defmodule SkillstackrWeb.JobFormLive do
  alias Skillstackr.Jobs.Job
  alias Skillstackr.Jobs
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    job =
      case socket.assigns.live_action do
        :new -> %Job{}
      end

    socket =
      socket
      |> assign(:page_title, "New Job")
      |> assign(:form, to_form(Jobs.change_job(job)))

    {:ok, socket}
  end
end
