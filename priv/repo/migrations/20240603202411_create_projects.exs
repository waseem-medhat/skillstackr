defmodule Skillstackr.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :link_repo, :string
      add :link_website, :string
      add :profile_id, references(:profiles, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end
