defmodule SkillstackrWeb.ProfilesLive do
  alias Skillstackr.Accounts
  use SkillstackrWeb, :live_view
  import SkillstackrWeb.TechnologyComponents

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

    <i :if={length(@profiles) == 0} class="block opacity-50 my-5">No profiles</i>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 my-5">
      <div
        :for={p <- @profiles}
        class="relative bg-white dark:bg-slate-950/70 rounded-lg shadow-lg p-6 transition flex flex-col"
      >
        <hgroup class="mb-2">
          <h2 class="text-2xl font-bold">
            <%= p.full_name %>
            <.link class="font-medium text-base ms-1 text-neutral-500"><%= p.slug %></.link>
          </h2>
          <h3 class="text-lg font-semibold"><%= p.headline %></h3>
        </hgroup>

        <%= if p.summary do %>
          <p class="text-sm text-gray-500 dark:text-neutral-400 flex-grow">
            <%= p.summary %>
          </p>
        <% else %>
          <i class="text-sm text-gray-400 dark:text-neutral-700 flex-grow">
            No summary
          </i>
        <% end %>

        <section class="mt-5">
          <div class="flex gap-2">
            <.tech_badge :for={t <- p.profiles_technologies} tech={t.technology.name} size={18} />
          </div>
        </section>

        <div class="absolute top-6 right-6 flex gap-2 items-center">
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
    </div>
    """
  end
end
