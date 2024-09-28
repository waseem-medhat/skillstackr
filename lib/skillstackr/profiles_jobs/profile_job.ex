defmodule Skillstackr.ProfilesJobs.ProfileJob do
  @moduledoc """
  The ProfileJob schema and changeset.

  It defines the join table associating Jobs with Profiles.

  """
  alias Skillstackr.Jobs.Job
  alias Skillstackr.Profiles.Profile
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles_jobs" do
    timestamps(type: :utc_datetime)
    belongs_to :profile, Profile
    belongs_to :job, Job
  end

  @doc false
  def changeset(profile_job, attrs) do
    profile_job
    |> cast(attrs, [])
    |> cast_assoc(:profile, with: &Profile.changeset/2)
    |> cast_assoc(:job, with: &Job.changeset/2)
  end
end
