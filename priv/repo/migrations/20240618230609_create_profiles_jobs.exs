defmodule Skillstackr.Repo.Migrations.CreateProfilesJobs do
  use Ecto.Migration

  def change do
    create table(:profiles_jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :profile_id,
          references(:profiles, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      add :job_id,
          references(:jobs, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      timestamps(type: :utc_datetime, default: fragment("now()"))
    end

    create unique_index(:profiles_jobs, [:profile_id, :job_id])
  end
end
