defmodule Skillstackr.Technologies.Technology do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "technologies" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(technology, attrs) do
    technology
    |> cast(attrs, [])
    |> validate_required([])
  end
end
