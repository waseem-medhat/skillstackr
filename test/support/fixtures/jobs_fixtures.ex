defmodule Skillstackr.JobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skillstackr.Jobs` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, %{new_job: job}} =
      attrs
      |> Enum.into(%{})
      |> Skillstackr.Jobs.create_job()

    job
    |> Skillstackr.Repo.preload([:profiles_jobs])
  end
end
