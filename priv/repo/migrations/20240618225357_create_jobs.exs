defmodule Skillstackr.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :company, :string
      add :experience_years, :integer
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
