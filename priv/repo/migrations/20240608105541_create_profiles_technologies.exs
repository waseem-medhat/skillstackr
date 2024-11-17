defmodule Skillstackr.Repo.Migrations.CreateProfilesTechnologies do
  use Ecto.Migration

  def change do
    create table(:profiles_technologies, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :profile_id,
          references(:profiles, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      add :technology_id,
          references(:technologies, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      timestamps(type: :utc_datetime, default: fragment("(CURRENT_TIMESTAMP)"))
    end

    create unique_index(:profiles_technologies, [:profile_id, :technology_id])
  end
end
