defmodule Skillstackr.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Technologies
  alias Skillstackr.ProjectsTechnologies.ProjectTechnology
  alias Skillstackr.ProfilesProjects.ProfileProject
  alias Ecto.Multi
  alias Skillstackr.Repo
  alias Skillstackr.Projects.Project

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Repo.one!(
      from p in Project,
        preload: [
          projects_technologies: :technology,
          profiles_projects: :profile
        ],
        where: p.id == ^id
    )
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}, assoc_profiles \\ [], assoc_technologies \\ []) do
    Multi.new()
    |> Multi.insert(:new_project, Project.changeset(%Project{}, attrs))
    |> Multi.insert_all(:profiles_projects, ProfileProject, fn %{new_project: new_project} ->
      Enum.map(assoc_profiles, fn p -> %{project_id: new_project.id, profile_id: p.id} end)
    end)
    |> Multi.run(:technologies, fn _repo, _changes ->
      {:ok, Enum.map(assoc_technologies, &Technologies.get_or_create_technology/1)}
    end)
    |> Multi.insert_all(
      :projects_technologies,
      ProjectTechnology,
      fn %{new_project: new_project, technologies: technologies} ->
        IO.inspect(technologies, label: "TECHNOLOGIES")
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
        removed_project_technology_ids \\ [],
        new_tech_list \\ []
      ) do
    Multi.new()
    |> Multi.update(:project, Project.changeset(project, attrs))
    |> Multi.delete_all(
      :removed_technologies,
      from(pt in ProjectTechnology, where: pt.id in ^removed_project_technology_ids)
    )
    |> Multi.run(
      :new_technologies,
      fn _repo, _changes ->
        {:ok, Enum.map(new_tech_list, &Technologies.get_or_create_technology/1)}
      end
    )
    |> Multi.insert_all(
      :projects_technologies,
      ProjectTechnology,
      fn %{project: project, new_technologies: new_technologies} ->
        Enum.map(new_technologies, fn t -> %{project_id: project.id, technology_id: t.id} end)
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
