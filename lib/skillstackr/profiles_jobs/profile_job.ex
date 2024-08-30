defmodule Skillstackr.ProfilesJobs.ProfileJob do
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
    |> cast(attrs, [:profile_id, :job_id])
    |> unique_constraint([:profile_id, :job_id])
  end
end
