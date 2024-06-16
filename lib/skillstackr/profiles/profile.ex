defmodule Skillstackr.Profiles.Profile do
  alias Skillstackr.{Accounts, Projects, Technologies, Profiles}
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

    timestamps(type: :utc_datetime)
    belongs_to :account, Accounts.Account
    has_one :resume, Profiles.Resume
    many_to_many :projects, Projects.Project, join_through: "profiles_projects"
    many_to_many :technologies, Technologies.Technology, join_through: "profiles_technologies"
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
      :account_id
    ])
    |> cast_assoc(:technologies, with: &Technologies.Technology.changeset/2)
    |> cast_assoc(:resume, with: &Profiles.Resume.changeset/2)
    |> unique_constraint(:slug)
    |> validate_required([:full_name, :slug, :account_id])
    |> validate_length(:summary, max: 280)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/, message: "must be only lowercase letters, numbers, or dashes")
    |> validate_length(:slug, max: 30)
  end
end
