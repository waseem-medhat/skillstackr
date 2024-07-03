defmodule SkillstackrWeb.ProfilesLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    profiles =
      socket.assigns.current_account
      |> Accounts.get_account_profiles!()

    socket =
      socket
      |> assign(:page_title, "Profiles")
      |> assign(:profiles, profiles)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.page_heading page_title={@page_title} />

    <.info_box
      heading="All your profiles are listed here."
      body="You are encouraged to make as many as you need and tailor each one for certain job titles, companies, etc."
    />

    <.link navigate={~p"/profiles/new"}>
      <.button class="mt-5">
        <.icon name="hero-plus-mini" /> Create Profile
      </.button>
    </.link>

    <div :if={length(@profiles) == 0} class="my-5">
      <i>No profiles</i>
    </div>

    <div
      :for={p <- @profiles}
      class="relative bg-white dark:bg-slate-950/70 rounded-lg my-5 shadow-lg p-5 transition"
    >
      <hgroup class="flex-grow mb-2">
        <h1 class="text-2xl font-bold">
          <%= p.full_name %>
          <.link class="font-medium text-lg ms-1 text-neutral-500"><%= p.slug %></.link>
        </h1>
        <h2 class="text-lg font-semibold"><%= p.headline %></h2>
      </hgroup>

      <p><%= p.summary || "No summary" %></p>

      <section class="mt-5">
        <div class="flex gap-2">
          <TechnologyComponents.tech_badge
            :for={t <- p.profiles_technologies}
            tech={t.technology.name}
            size={18}
          />
        </div>
      </section>

      <div class="absolute top-5 right-5 flex gap-2 items-center">
        <.link
          navigate={~p"/profiles/#{p.slug}"}
          class="bg-indigo-700 text-white rounded-lg p-1.5 inline-flex items-center hover:bg-indigo-500 z-10 text-sm gap-1"
        >
          <.icon name="hero-eye-micro" />
        </.link>

        <.link
          navigate={~p"/profiles/#{p.slug}/edit"}
          class="bg-indigo-700 text-white rounded-lg p-1.5 inline-flex items-center hover:bg-indigo-500 z-10 text-sm gap-1"
        >
          <.icon name="hero-pencil-square-micro" />
        </.link>
      </div>
    </div>
    """
  end
end
