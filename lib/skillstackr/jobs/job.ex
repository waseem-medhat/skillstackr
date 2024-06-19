defmodule Skillstackr.Jobs.Job do
  alias Skillstackr.Profiles
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jobs" do
    field :title, :string
    field :company, :string
    field :experience_years, :integer
    field :description, :string

    timestamps(type: :utc_datetime)
    many_to_many :profiles, Profiles.Profile, join_through: "profiles_jobs"
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:title, :company, :experience_years, :description])
    |> validate_required([:title, :company, :experience_years])
  end
end