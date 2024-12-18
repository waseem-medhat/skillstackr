defmodule Skillstackr.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Skillstackr.ProfilesJobs.ProfileJob
  alias Skillstackr.Repo

  alias Skillstackr.Jobs.Job

  @doc """
  Gets a single job with the given ID, preloading associated profiles. Returns
  `nil` if it doesn't exist.

  ## Examples

      iex> get_job(123)
      %Job{}

      iex> get_job(456)
      nil

  """
  def get_job(id) do
    Repo.one(
      from j in Job,
        preload: [profiles_jobs: :profile],
        where: j.id == ^id
    )
  end

  @doc """
  Creates a job and adds its profile associations via a database transaction.
  It takes the following arguments:

  - `attrs`: a map of attributes for the new job (`%{key: value}`)
  - `assoc_profile_ids`: a list of profile IDs to be associated with the new
  job

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %{job: %Job{}, profiles_jobs: []}}

      iex> create_job(%{field: bad_value})
      {:error, :job, %Ecto.Changeset{}, []}

  """
  def create_job(attrs \\ %{}, assoc_profile_ids \\ []) do
    Multi.new()
    |> Multi.insert(:job, Job.changeset(%Job{}, attrs))
    |> Multi.insert_all(:profiles_jobs, ProfileJob, fn %{job: job} ->
      Enum.map(assoc_profile_ids, fn profile_id -> %{job_id: job.id, profile_id: profile_id} end)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a job and its profile associations via a database transaction. It
  takes the following arguments:

  - `job`, the job struct to be updated
  - `attrs`, a map of attributes for updating the job (`%{key: value}`)
  - `profile_job_id_deletions`, a list of profile-job association IDs to delete
  - `assoc_profile_id_insertions`, a list of profile IDs to insert new
  associations

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %{job: %Job{}}}

      iex> update_job(job, %{field: bad_value})
      {:error, :job, %Ecto.Changeset{}}

  """
  def update_job(
        %Job{} = job,
        attrs \\ %{},
        profile_job_id_deletions \\ [],
        assoc_profile_id_insertions \\ []
      ) do
    Multi.new()
    |> Multi.update(:updated_job, Job.changeset(job, attrs))
    |> Multi.delete_all(
      :removed_profiles_jobs,
      from(pj in ProfileJob, where: pj.id in ^profile_job_id_deletions)
    )
    |> Multi.insert_all(
      :profiles_jobs,
      ProfileJob,
      fn %{updated_job: updated_job} ->
        Enum.map(assoc_profile_id_insertions, fn id ->
          %{job_id: updated_job.id, profile_id: id}
        end)
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
