defmodule Skillstackr.ProfilesTechnologies.ProfileTechnology do
  @moduledoc """
  The ProfileTechnology schema and changeset.

  It defines the join table associating Technologies with Profiles.

  """
  alias Skillstackr.Profiles.Profile
  alias Skillstackr.Technologies.Technology
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles_technologies" do
    timestamps(type: :utc_datetime)
    belongs_to :profile, Profile
    belongs_to :technology, Technology
  end

  @doc false
  def changeset(profile_technology, attrs) do
    profile_technology
    |> cast(attrs, [])
    |> cast_assoc(:profile, with: &Profile.changeset/2)
    |> cast_assoc(:technology, with: &Technology.changeset/2)
  end
end
