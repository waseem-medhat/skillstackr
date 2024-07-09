defmodule SkillstackrWeb.JobsLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.ProfileComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:jobs, Accounts.get_account_jobs(socket.assigns.current_account))
      |> assign(:page_title, "Job Experience")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.page_heading page_title={@page_title} />

    <.info_box
      heading="All your job experience data are listed here."
      body="Any job experience can be added to one or more profiles."
    />

    <.link navigate={~p"/jobs/new"}>
      <.button class="my-5">
        <.icon name="hero-plus-mini" /> Add Job Experience
      </.button>
    </.link>

    <p :if={length(@jobs) == 0} class="mt-5 italic opacity-60">No job experience yet.</p>

    <.job_accordion jobs={@jobs} editable={true} />
    """
  end
end
