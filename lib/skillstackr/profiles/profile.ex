defmodule Skillstackr.Profiles.Profile do
  alias Skillstackr.Accounts.Account
  alias Skillstackr.Profiles.Resume
  alias Skillstackr.ProfilesJobs.ProfileJob
  alias Skillstackr.ProfilesProjects.ProfileProject
  alias Skillstackr.Technologies.Technology
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
    belongs_to :account, Account
    has_one :resume, Resume, on_delete: :delete_all
    has_many :profiles_projects, ProfileProject, on_delete: :delete_all
    has_many :profiles_jobs, ProfileJob, on_delete: :delete_all

    many_to_many :technologies, Technology,
      join_through: "profiles_technologies",
      on_replace: :delete,
      on_delete: :delete_all
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
    |> cast_assoc(:technologies, with: &Technology.changeset/2)
    |> cast_assoc(:resume, with: &Resume.changeset/2)
    |> unique_constraint(:slug)
    |> validate_required([:full_name, :slug, :account_id])
    |> validate_length(:summary, max: 280)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
      message: "must be only lowercase letters, numbers, or dashes"
    )
    |> validate_length(:slug, max: 30)
  end
end
