defmodule Skillstackr.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
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
  Creates a job and adds its profile associations. It takes the following
  arguments:

  - `attrs`: a map of attributes for the new job

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %{job: %Job{}, profiles_jobs: []}}

      iex> create_job(%{field: bad_value})
      {:error, :job, %Ecto.Changeset{}, []}

  """
  def create_job(attrs \\ %{}) do
    Repo.insert(Job.changeset(%Job{}, attrs))
  end

  @doc """
  Updates a job and its profile associations. It takes the following arguments:

  - `job`, the job struct to be updated
  - `attrs`, a map of attributes for updating the job

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %{job: %Job{}}}

      iex> update_job(job, %{field: bad_value})
      {:error, :job, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs \\ %{}) do
    Repo.update(Job.changeset(job, attrs))
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
