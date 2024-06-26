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

    job_params =
      params["job"]
      |> Map.put("account_id", socket.assigns.current_account.id)

    case Jobs.create_job(job_params, assoc_profiles) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience added")
         |> redirect(to: ~p"/jobs")}

      {:error, :new_job, changeset, _} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.page_heading page_title={@page_title} />
      <section class="grid grid-cols-2 gap-8">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:company]} type="text" label="Company" />
        <.input field={@form[:experience_years]} type="number" label="Years of Experience" />
        <div class="col-span-2">
          <.input field={@form[:description]} type="textarea" label="Description" />
        </div>
      </section>
      <section>
        <.label>Add to Profiles</.label>
        <ul class="my-2 space-y-1">
          <.input :for={p <- @profiles} type="checkbox" label={p.slug} name={p.slug} />
        </ul>
      </section>

      <:actions>
        <.button type="submit">Save Profile</.button>
      </:actions>
    </.simple_form>
    """
  end
end
