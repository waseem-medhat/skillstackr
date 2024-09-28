defmodule Skillstackr.ProfilesProjects.ProfileProject do
  @moduledoc """
  The ProfileProject schema and changeset.

  It defines the join table associating Projects with Profiles.

  """
  alias Skillstackr.Projects.Project
  alias Skillstackr.Profiles.Profile
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles_projects" do
    timestamps(type: :utc_datetime)
    belongs_to :profile, Profile
    belongs_to :project, Project
  end

  @doc false
  def changeset(profile_project, attrs) do
    profile_project
    |> cast(attrs, [])
    |> cast_assoc(:profile, with: &Profile.changeset/2)
    |> cast_assoc(:project, with: &Project.changeset/2)
  end
end
