defmodule Skillstackr.Profiles.Profile do
  alias Skillstackr.Projects
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :full_name, :string
    field :headline, :string
    field :summary, :string
    field :slug, :string
    field :link_github, :string
    field :link_linkedin, :string
    field :link_website, :string
    field :resume, :binary

    timestamps(type: :utc_datetime)
    has_many :projects, Projects.Project
    many_to_many :technologies, Technology, join_through: "profiles_technologies"
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :full_name,
      :headline,
      :summary,
      :slug,
      :link_github,
      :link_linkedin,
      :link_website,
      :resume
    ])
    |> unique_constraint(:slug)
    |> validate_required([:full_name, :slug, :resume])
    |> validate_length(:summary, max: 280)
    |> validate_length(:resume, max: 5_000_000, count: :bytes, message: "must be smaller than 5 MB")
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must be only lowercase letters, numbers, or dashes")
    |> validate_length(:slug, max: 30)
  end
end
