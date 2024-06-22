defmodule Skillstackr.ProfilesJobs.ProfileJob do
  alias Skillstackr.Jobs
  alias Skillstackr.Profiles
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "profiles_jobs" do
    timestamps(type: :utc_datetime)
    has_many :profiles, Profiles.Profile, on_delete: :delete_all
    has_many :jobs, Jobs.Job, on_delete: :delete_all
  end
  
  @doc false
  def changeset(profile_job, attrs) do
    profile_job
    |> cast(attrs, [])
  end
end
