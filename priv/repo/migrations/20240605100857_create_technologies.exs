defmodule Skillstackr.Repo.Migrations.CreateTechnologies do
  use Ecto.Migration

  def change do
    create table(:technologies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :category, :string
    end
  end
end
