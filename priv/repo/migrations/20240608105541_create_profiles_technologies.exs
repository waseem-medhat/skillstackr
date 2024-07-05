defmodule Skillstackr.Repo.Migrations.CreateProfilesTechnologies do
  use Ecto.Migration

  def change do
    create table(:profiles_technologies) do
      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all)
      add :technology_id, references(:technologies, type: :binary_id, on_delete: :delete_all)
      timestamps(type: :utc_datetime, default: fragment("(CURRENT_TIMESTAMP)"))
    end
  end
end
