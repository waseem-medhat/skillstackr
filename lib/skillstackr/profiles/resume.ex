defmodule Skillstackr.Profiles.Resume do
  alias Skillstackr.Profiles.Profile
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "resumes" do
    field :blob, :binary

    belongs_to :profile, Profile
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resume, attrs) do
    resume
    |> cast(attrs, [:blob])
    |> validate_length(:blob, max: 5_000_000, count: :bytes, message: "must be smaller than 5 MB")
  end
end
