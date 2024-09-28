defmodule Skillstackr.Projects.Project do
  @moduledoc """
  The Project schema and changeset

  A Project struct holds data about a portfolio project and can be associated
  with profiles.

  """
  alias Skillstackr.Accounts.Account
  alias Skillstackr.ProjectsTechnologies.ProjectTechnology
  alias Skillstackr.ProfilesProjects.ProfileProject
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :title, :string
    field :description, :string
    field :link_repo, :string
    field :link_website, :string

    belongs_to :account, Account
    has_many :profiles_projects, ProfileProject
    has_many :projects_technologies, ProjectTechnology
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :link_repo, :link_website, :account_id])
    |> validate_required([:title])
  end
end
