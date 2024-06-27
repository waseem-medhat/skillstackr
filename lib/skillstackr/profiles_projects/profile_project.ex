defmodule Skillstackr.ProfilesProjects.ProfileProject do
  alias Skillstackr.Projects
  alias Skillstackr.Profiles
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "profiles_projects" do
    timestamps(type: :utc_datetime)
    belongs_to :profile, Profiles.Profile
    belongs_to :project, Projects.Project
  end
  
  @doc false
  def changeset(profile_job, attrs) do
    profile_job
    |> cast(attrs, [])
    |> cast_assoc(:profile, with: &Profiles.Profile.changeset/2)
    |> cast_assoc(:project, with: &Projects.Project.changeset/2)
  end
end
