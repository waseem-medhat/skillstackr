defmodule Skillstackr.ProjectsTechnologies.ProjectTechnology do
  @moduledoc """
  The ProjectTechnology schema and changeset.

  It defines the join table associating Technologies with Projects.

  """
  alias Skillstackr.Projects.Project
  alias Skillstackr.Technologies.Technology
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects_technologies" do
    timestamps(type: :utc_datetime)
    belongs_to :project, Project
    belongs_to :technology, Technology
  end

  @doc false
  def changeset(profile_job, attrs) do
    profile_job
    |> cast(attrs, [])
    |> cast_assoc(:project, with: &Project.changeset/2)
    |> cast_assoc(:technology, with: &Technology.changeset/2)
  end
end
