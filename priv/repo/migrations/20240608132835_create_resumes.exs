defmodule Skillstackr.Repo.Migrations.CreateResumes do
  use Ecto.Migration

  def change do
    create table(:resumes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :blob, :binary
      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
