defmodule Skillstackr.Repo.Migrations.AddAccountJobRelation do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :account_id, references(:accounts, type: :binary_id, on_delete: :delete_all), null: false
    end
  end
end
