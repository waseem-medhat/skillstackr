defmodule Skillstackr.Repo.Migrations.CreateProfilesTechnologies do
  use Ecto.Migration

  def change do
    create table(:profiles_technologies, primary_key: false) do
      add :profile_id,
          references(:profiles, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      add :technology_id,
          references(:technologies, type: :binary_id, on_delete: :delete_all),
          primary_key: true

      timestamps(type: :utc_datetime, default: fragment("(CURRENT_TIMESTAMP)"))
    end
  end
end
