defmodule SkillstackrWeb.JobFormLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Jobs.Job
  alias Skillstackr.Jobs
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    job =
      case socket.assigns.live_action do
        :new -> %Job{}
      end

    profiles = Profiles.list_profiles()

    socket =
      socket
      |> assign(:page_title, "Add Job Experience")
      |> assign(:profiles, profiles)
      |> assign(:form, to_form(Jobs.change_job(job)))

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    profile_slugs =
      params
      |> Map.drop(["job"])
      |> Enum.filter(fn {_slug, selected} -> selected == "true" end)
      |> Enum.map(fn {slug, "true"} -> slug end)

    Jobs.create_job(params["job"], profile_slugs)
    |> IO.inspect(label: "JOB CHANGESET")

    {:noreply, socket}
  end
end
