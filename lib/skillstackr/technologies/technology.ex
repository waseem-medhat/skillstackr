defmodule Skillstackr.Technologies.Technology do
  alias Skillstackr.Profiles
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "technologies" do
    field :name, :string
    field :category, :string

    many_to_many :profiles, Profiles.Profile, join_through: "profiles_technologies"
  end

  @doc false
  def changeset(technology, attrs) do
    technology
    |> cast(attrs, [:name, :category])
    |> validate_required([:name, :category])
  end
end
