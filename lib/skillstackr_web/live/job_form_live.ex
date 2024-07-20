defmodule SkillstackrWeb.JobFormLive do
  alias Skillstackr.Accounts
  alias Skillstackr.Jobs.Job
  alias Skillstackr.Jobs
  use SkillstackrWeb, :live_view

  def mount(_params, _session, %{assigns: %{live_action: :new}} = socket) do
    {:ok, assign_with_data(socket, %Job{profiles_jobs: []})}
  end

  def mount(%{"id" => id}, _session, %{assigns: %{live_action: :edit}} = socket) do
    case Jobs.get_job(id) do
      nil ->
        {:ok, socket |> put_flash(:error, "Job doesn't exist") |> redirect(to: ~p"/jobs")}

      job ->
        {:ok, assign_with_data(socket, job)}
    end
  end

  defp assign_with_data(socket, job) do
    socket
    |> assign(:page_title, "Add Job Experience")
    |> assign(:account_profiles, Accounts.get_account_profiles!(socket.assigns.current_account))
    |> assign(:job, job)
    |> assign(:form, to_form(Jobs.change_job(job)))
  end

  def handle_event("validate", params, socket) do
    new_form =
      Jobs.change_job(%Job{}, params["job"])
      |> Map.put(:action, :validate)
      |> to_form(as: "job")

    {:noreply, assign(socket, :form, new_form)}
  end

  def handle_event("save", params, %{assigns: %{live_action: :new}} = socket) do
    assoc_profiles =
      socket.assigns.account_profiles
      |> Enum.filter(fn acc_p -> params[acc_p.slug] === "true" end)

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

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    %{
      account_profiles: account_profiles,
      job: %{
        profiles_jobs: current_profiles_jobs
      }
    } =
      socket.assigns

    new_profiles =
      account_profiles
      |> Enum.filter(fn acc_p -> params[acc_p.slug] === "true" end)

    {prof_job_id_deletions, prof_insertions} =
      diff_profiles(current_profiles_jobs, new_profiles)

    Jobs.update_job(
      socket.assigns.job,
      params["job"],
      prof_job_id_deletions,
      prof_insertions
    )
    |> case do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience saved!")
         |> redirect(to: ~p"/jobs")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp diff_profiles(current_profiles_jobs, new_profiles) do
    prof_job_id_deletions =
      current_profiles_jobs
      |> Enum.filter(fn %{profile: profile} ->
        profile.id not in Enum.map(new_profiles, & &1.id)
      end)
      |> IO.inspect()
      |> Enum.map(& &1.id)

    prof_insertions =
      new_profiles
      |> Enum.filter(fn profile ->
        profile.id not in Enum.map(current_profiles_jobs, & &1.profile.id)
      end)

    {prof_job_id_deletions, prof_insertions}
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
          <.input
            :for={acc_p <- @account_profiles}
            type="checkbox"
            label={acc_p.slug}
            name={acc_p.slug}
            checked={acc_p.slug in Enum.map(@job.profiles_jobs, & &1.profile.slug)}
          />
        </ul>
      </section>

      <:actions>
        <.button type="submit">Save Profile</.button>
      </:actions>
    </.simple_form>
    """
  end
end
