defmodule Skillstackr.Repo.Migrations.CreateProfilesJobs do
  use Ecto.Migration

  def change do
    create table(:profiles_jobs, primary_key: false) do
      add :profile_id, references(:profiles, type: :binary_id), primary_key: true
      add :job_id, references(:jobs, type: :binary_id), primary_key: true

      timestamps(type: :utc_datetime)
    end
  end
end
