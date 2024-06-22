defmodule Skillstackr.Repo.Migrations.AddProfileJobRelation do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :profile_job_id, references(:profiles_jobs, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
