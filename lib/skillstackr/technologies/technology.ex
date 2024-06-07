defmodule Skillstackr.Technologies.Technology do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "technologies" do
    field :name, :string

    timestamps(type: :utc_datetime)
    many_to_many :profiles, Profile, join_through: "profiles_technologies"
  end

  @doc false
  def changeset(technology, attrs) do
    technology
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
