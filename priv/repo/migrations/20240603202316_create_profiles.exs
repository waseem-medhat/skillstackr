defmodule Skillstackr.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string
      add :headline, :string
      add :slug, :string, null: false
      add :summary, :string
      add :link_github, :string
      add :link_linkedin, :string
      add :link_website, :string
      add :link_resume, :string

      timestamps(type: :utc_datetime)
    end
  end
end