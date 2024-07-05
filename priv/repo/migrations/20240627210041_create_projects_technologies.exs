defmodule Skillstackr.Repo.Migrations.CreateProjectsTechnologies do
  use Ecto.Migration

  def change do
    create table(:projects_technologies, primary_key: false) do
      add :project_id,
          references(:projects, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      add :technology_id,
          references(:technologies, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      timestamps(type: :utc_datetime, default: fragment("(CURRENT_TIMESTAMP)"))
    end
  end
end
