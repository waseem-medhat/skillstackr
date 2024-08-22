defmodule Skillstackr.Repo.Migrations.AddAccountProfileRelation do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :account_id, references(:accounts, type: :binary_id, on_delete: :delete_all),
        null: false
    end
  end
end
