defmodule Skillstackr.Profiles.Profile do
  alias Skillstackr.ProfilesTechnologies.ProfileTechnology
  alias Skillstackr.Accounts.Account
  alias Skillstackr.ProfilesJobs.ProfileJob
  alias Skillstackr.ProfilesProjects.ProfileProject
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :full_name, :string
    field :headline, :string
    field :summary, :string
    field :slug, :string
    field :email, :string
    field :link_github, :string
    field :link_linkedin, :string
    field :link_website, :string

    timestamps(type: :utc_datetime)
    belongs_to :account, Account
    has_many :profiles_projects, ProfileProject
    has_many :profiles_jobs, ProfileJob
    has_many :profiles_technologies, ProfileTechnology
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :full_name,
      :headline,
      :summary,
      :slug,
      :email,
      :link_github,
      :link_linkedin,
      :link_website,
      :account_id
    ])
    |> unique_constraint(:slug)
    |> validate_required([:full_name, :slug, :account_id])
    |> validate_length(:summary, max: 280)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
      message: "must be only lowercase letters, numbers, or dashes"
    )
    |> validate_length(:slug, max: 30)
  end
end
