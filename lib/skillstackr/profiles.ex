defmodule Skillstackr.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Projects.Project
  alias Skillstackr.ProfilesTechnologies.ProfileTechnology
  alias Skillstackr.Technologies.Technology
  alias Ecto.Multi
  alias Skillstackr.Technologies
  alias Skillstackr.Repo

  alias Skillstackr.Profiles.Profile

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Gets a single profile associated with the given slug.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!("johndoe")
      %Profile{}

      iex> get_profile!("noone")
      ** (Ecto.NoResultsError)

  """
  def get_profile_by_slug!(slug) do
    Repo.one!(
      from p in Profile,
        preload: [
          profiles_technologies: :technology,
          profiles_jobs: :job,
          profiles_projects: [
            project: [projects_technologies: :technology]
          ]
        ],
        where: p.slug == ^slug
    )
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}, assoc_technologies \\ []) do
    Multi.new()
    |> Multi.insert(:profile, Profile.changeset(%Profile{}, attrs))
    |> Multi.run(:technologies, fn _repo, _changes ->
      {:ok, Enum.map(assoc_technologies, &Technologies.get_or_create_technology/1)}
    end)
    |> Multi.insert_all(
      :profiles_technologies,
      ProfileTechnology,
      fn %{profile: profile, technologies: technologies} ->
        Enum.map(technologies, fn t -> %{profile_id: profile.id, technology_id: t.id} end)
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(
        %Profile{} = profile,
        attrs,
        removed_profile_technology_ids \\ [],
        new_tech_list \\ []
      ) do
    Multi.new()
    |> Multi.update(:profile, Profile.changeset(profile, attrs))
    |> Multi.delete_all(
      :removed_technologies,
      from(pt in ProfileTechnology, where: pt.id in ^removed_profile_technology_ids)
    )
    |> Multi.run(:new_technologies, fn _repo, _changes ->
      {:ok, Enum.map(new_tech_list, &Technologies.get_or_create_technology/1)}
    end)
    |> Multi.insert_all(
      :profiles_technologies,
      ProfileTechnology,
      fn %{profile: profile, new_technologies: new_technologies} ->
        Enum.map(new_technologies, fn t -> %{profile_id: profile.id, technology_id: t.id} end)
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

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
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
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

  alias Skillstackr.Profiles.Resume

  @doc """
  Gets a single resume.

  Raises `Ecto.NoResultsError` if the Resume does not exist.

  ## Examples

      iex> get_resume!(123)
      %Resume{}

      iex> get_resume!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resume_blob!(slug) do
    Repo.one!(
      from p in Profile,
        join: r in Resume,
        on: r.profile_id == p.id,
        where: p.slug == ^slug,
        select: r.blob
    )
  end

  @doc """
  Creates a resume.

  ## Examples

      iex> create_resume(%{field: value})
      {:ok, %Resume{}}

      iex> create_resume(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resume(attrs \\ %{}) do
    %Resume{}
    |> Resume.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resume.

  ## Examples

      iex> update_resume(resume, %{field: new_value})
      {:ok, %Resume{}}

      iex> update_resume(resume, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resume(%Resume{} = resume, attrs) do
    resume
    |> Resume.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a resume.

  ## Examples

      iex> delete_resume(resume)
      {:ok, %Resume{}}

      iex> delete_resume(resume)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resume(%Resume{} = resume) do
    Repo.delete(resume)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resume changes.

  ## Examples

      iex> change_resume(resume)
      %Ecto.Changeset{data: %Resume{}}

  """
  def change_resume(%Resume{} = resume, attrs \\ %{}) do
    Resume.changeset(resume, attrs)
  end
end
