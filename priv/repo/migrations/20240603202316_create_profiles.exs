defmodule Skillstackr.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string
      add :headline, :string
      add :slug, :string, null: false
      add :email, :string
      add :summary, :string
      add :link_github, :string
      add :link_linkedin, :string
      add :link_website, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profiles, [:slug])
  end
end
