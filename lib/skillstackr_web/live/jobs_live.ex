defmodule SkillstackrWeb.JobsLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view

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

    <p :if={length(@jobs) == 0} class="mt-5 italic opacity-60">No job experience yet.</p>

    <section>
      <div
        :for={j <- @jobs}
        class="relative bg-white dark:bg-slate-950/70 rounded-lg my-5 shadow-lg p-5 transition"
      >
        <h1 class="text-xl font-bold">
          <%= j.experience_years %> years @ <%= j.company %>
        </h1>
        <p><%= j.description %></p>
      </div>
    </section>

    <.link navigate={~p"/jobs/new"}>
      <.button class="mt-5">
        <.icon name="hero-plus-mini" /> Add Job Experience
      </.button>
    </.link>
    """
  end
end
