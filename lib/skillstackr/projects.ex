defmodule Skillstackr.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Technologies
  alias Skillstackr.Technologies.Technology
  alias Skillstackr.ProjectsTechnologies.ProjectTechnology
  alias Skillstackr.ProfilesProjects.ProfileProject
  alias Ecto.Multi
  alias Skillstackr.Repo
  alias Skillstackr.Projects.Project

  @doc """
  Gets a single project with the given ID, preloading associated profiles and
  technologies. Returns `nil` if it doesn't exist.

  ## Examples

      iex> get_project(123)
      %Project{}

      iex> get_project(456)
      nil

  """
  def get_project(id) do
    Repo.one(
      from p in Project,
        preload: [
          projects_technologies: :technology,
          profiles_projects: :profile
        ],
        where: p.id == ^id
    )
  end

  @doc """
  Creates a project and associated technologies through a database transaction.
  Creating new technologies if they don't already exist is part of the
  transaction as well. It takes the following arguments:

  - `attrs`: a map of attributes for the new project (`%{key: value}`)
  - `assoc_profile_ids`: a list of profile IDs to be associated with the new
  project
  - `assoc_technologies`: a list of maps for technologies to be associated with
  the new project (`[%{"name" => "tech_name", "category" => "tech_category"}]`)

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %{new_project: %Project{}}}

      iex> create_project(%{field: bad_value})
      {:error, :new_project, %Ecto.Changeset{}, []}

  """
  def create_project(attrs \\ %{}, assoc_profile_ids \\ [], assoc_technologies \\ []) do
    Multi.new()
    |> Multi.insert(:project, Project.changeset(%Project{}, attrs))
    |> Multi.insert_all(
      :profiles_projects,
      ProfileProject,
      fn %{project: project} ->
        Enum.map(assoc_profile_ids, fn profile_id ->
          %{project_id: project.id, profile_id: profile_id}
        end)
      end
    )
    |> Multi.insert_all(:tech_upsert, Technology, assoc_technologies, on_conflict: :nothing)
    |> Multi.all(:technologies, Technologies.build_search_query(assoc_technologies))
    |> Multi.insert_all(
      :projects_technologies,
      ProjectTechnology,
      fn %{project: new_project, technologies: technologies} ->
        Enum.map(technologies, fn t -> %{project_id: new_project.id, technology_id: t.id} end)
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(
        %Project{} = project,
        attrs,
        proj_tech_id_deletions \\ [],
        assoc_technologies \\ [],
        prof_proj_id_deletions \\ [],
        prof_insertions \\ []
      ) do
    Multi.new()
    |> Multi.update(:project, Project.changeset(project, attrs))
    |> Multi.delete_all(
      :removed_technologies,
      from(pt in ProjectTechnology, where: pt.id in ^proj_tech_id_deletions)
    )
    |> Multi.insert_all(:tech_upsert, Technology, assoc_technologies, on_conflict: :nothing)
    |> Multi.all(:technologies, Technologies.build_search_query(assoc_technologies))
    |> Multi.insert_all(
      :projects_technologies,
      ProjectTechnology,
      fn %{project: project, technologies: technologies} ->
        Enum.map(technologies, fn t -> %{project_id: project.id, technology_id: t.id} end)
      end,
      on_conflict: :nothing
    )
    |> Multi.delete_all(
      :removed_profiles_projects,
      from(pp in ProfileProject, where: pp.id in ^prof_proj_id_deletions)
    )
    |> Multi.insert_all(
      :profiles_projects,
      ProfileProject,
      fn %{project: project} ->
        Enum.map(prof_insertions, fn p -> %{project_id: project.id, profile_id: p.id} end)
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
