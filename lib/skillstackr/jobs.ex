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
  Gets a single job with the given ID. Returns `nil` if it doesn't exist.

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
  Creates a job and adds its associations with profiles.

  ## Examples

      iex> create_job(%field: value)
      {:ok, %{new_job: %Job{}, profiles_jobs: []}}

      iex> create_job(%{field: bad_value})
      {:error, :new_job, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}, assoc_profiles \\ []) do
    Multi.new()
    |> Multi.insert(:new_job, Job.changeset(%Job{}, attrs))
    |> Multi.insert_all(:profiles_jobs, ProfileJob, fn %{new_job: new_job} ->
      Enum.map(assoc_profiles, fn p -> %{job_id: new_job.id, profile_id: p.id} end)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a job. Associations with profiles are also added or deleted as
  necessary.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %{job: %Job{}}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs, prof_job_id_deletions \\ [], prof_insertions \\ []) do
    Multi.new()
    |> Multi.update(:job, Job.changeset(job, attrs))
    |> Multi.delete_all(
      :removed_profiles_jobs,
      from(pj in ProfileJob, where: pj.id in ^prof_job_id_deletions)
    )
    |> Multi.insert_all(
      :profiles_jobs,
      ProfileJob,
      fn %{job: job} ->
        Enum.map(prof_insertions, fn p -> %{job_id: job.id, profile_id: p.id} end)
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
