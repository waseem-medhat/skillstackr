defmodule Skillstackr.Projects.Project do
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

    has_many :profiles_projects, ProfileProject, on_delete: :delete_all
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [])
    |> validate_required([])
  end
end
