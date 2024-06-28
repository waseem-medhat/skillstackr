defmodule Skillstackr.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Jobs.Job
  alias Skillstackr.ProfilesTechnologies.ProfileTechnology
  alias Skillstackr.Technologies.Technology
  alias Ecto.Multi
  alias Skillstackr.Technologies
  alias Skillstackr.Repo

  alias Skillstackr.Profiles.Profile

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

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
    profile =
      Repo.one!(
        from p in Profile,
          preload: [:profiles_technologies, :profiles_jobs],
          where: p.slug == ^slug
      )

    technology_ids = Enum.map(profile.profiles_technologies, & &1.technology_id)
    technologies = Repo.all(from t in Technology, where: t.id in ^technology_ids)

    job_ids = Enum.map(profile.profiles_jobs, & &1.job_id)
    jobs = Repo.all(from j in Job, where: j.id in ^job_ids)

    %{profile: profile, technologies: technologies, jobs: jobs}
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
      {:ok, Enum.map(assoc_technologies, &get_or_create_technology/1)}
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

  defp get_or_create_technology(%{"name" => name, "category" => category} = tech_attrs) do
    query =
      from t in Technology,
        where: t.name == ^name and t.category == ^category

    case Repo.one(query) do
      nil ->
        case Technologies.create_technology(tech_attrs) do
          {:ok, tech} -> tech
          {:error, _} -> nil
        end

      tech ->
        tech
    end
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
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
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

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
  Returns the list of resumes.

  ## Examples

      iex> list_resumes()
      [%Resume{}, ...]

  """
  def list_resumes do
    Repo.all(Resume)
  end

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
