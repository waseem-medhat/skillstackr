defmodule Skillstackr.Repo.Migrations.CreateProfilesProjects do
  use Ecto.Migration

  def change do
    create table(:profiles_projects, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :profile_id,
          references(:profiles, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      add :project_id,
          references(:projects, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      timestamps(type: :utc_datetime, default: fragment("(CURRENT_TIMESTAMP)"))
    end
  end
end
