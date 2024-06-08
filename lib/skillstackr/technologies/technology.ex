defmodule Skillstackr.Technologies.Technology do
  alias Skillstackr.Profiles
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "technologies" do
    field :name, :string

    many_to_many :profiles, Profiles.Profile, join_through: "profiles_technologies"
  end

  @doc false
  def changeset(technology, attrs) do
    technology
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
