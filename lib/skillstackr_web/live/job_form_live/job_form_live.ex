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

  def handle_event("validate", params, socket) do
    new_form =
      Jobs.change_job(%Job{}, params["job"])
      |> Map.put(:action, :validate)
      |> to_form(as: "job")

    {:noreply, assign(socket, :form, new_form)}
  end

  def handle_event("save", params, socket) do
    assoc_profiles =
      socket.assigns.profiles
      |> Enum.filter(fn p -> params[p.slug] === "true" end)

    case Jobs.create_job(params["job"], assoc_profiles) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience added")
         |> redirect(to: ~p"/jobs")}

      {:error, :new_job, changeset, _} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
