defmodule Skillstackr.Repo.Migrations.CreateProfilesJobs do
  use Ecto.Migration

  def change do
    create table(:profiles_jobs) do
      add :profile_id, references(:profiles, type: :binary_id)
      add :job_id, references(:jobs, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end
