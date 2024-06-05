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
    field :link_resume, :string

    has_many :projects, Projects.Project
    timestamps(type: :utc_datetime)
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
      :link_resume
    ])
    |> validate_required([:full_name, :slug])
    |> unique_constraint(:slug)
    |> validate_length(:summary, max: 140)
  end
end
