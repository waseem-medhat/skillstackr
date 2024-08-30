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
    job_params = prep_job_params(params, socket.assigns)

    case Jobs.create_job(job_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience added")
         |> redirect(to: ~p"/jobs")}

      {:error, :job, changeset, _} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", params, %{assigns: %{live_action: :edit}} = socket) do
    job_params = prep_job_params(params, socket.assigns)

    case Jobs.update_job(socket.assigns.job, job_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience saved!")
         |> redirect(to: ~p"/jobs")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("delete", _params, socket) do
    case Jobs.delete_job(socket.assigns.job) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job experience deleted successfully!")
         |> redirect(to: "/jobs")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "An error occurred!")}
    end
  end

  defp prep_job_params(params, assigns) do
    assoc_profile_params =
      assigns.account_profiles
      |> Enum.filter(fn account_profile -> params[account_profile.slug] === "true" end)
      |> Enum.map(fn profile ->
        %{"profile_id" => profile.id, "job_id" => assigns.job.id}
      end)

    params["job"]
    |> Map.put("profiles_jobs", assoc_profile_params)
    |> Map.put("account_id", assigns.current_account.id)
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

    <section :if={@live_action == :edit} class="pb-36">
      <hr class="dark:border-gray-800 my-8" />

      <.button
        id="delete-button"
        style="outline-red"
        phx-click={
          JS.remove_class("hidden", to: "#confirm-prompt")
          |> JS.add_class("hidden", to: "#delete-button")
        }
      >
        Delete Job Experience
      </.button>

      <div id="confirm-prompt" class="hidden">
        <p class="my-6">
          This will permanently delete the job experience and remove its
          association from all profiles. Proceed?
        </p>

        <.button
          style="outline"
          phx-click={
            JS.add_class("hidden", to: "#confirm-prompt")
            |> JS.remove_class("hidden", to: "#delete-button")
          }
        >
          Cancel
        </.button>

        <.button phx-click="delete" style="outline-red">Confirm and Delete</.button>
      </div>
    </section>
    """
  end
end
