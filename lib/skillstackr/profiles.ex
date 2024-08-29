defmodule Skillstackr.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.ProfilesTechnologies.ProfileTechnology
  alias Ecto.Multi
  alias Skillstackr.Technologies
  alias Skillstackr.Technologies.Technology
  alias Skillstackr.Repo

  alias Skillstackr.Profiles.Profile

  @doc """
  Gets a single profile associated with the given slug. Returns `nil` if the
  Profile does not exist.

  ## Examples

      iex> get_profile!("johndoe")
      %Profile{}

      iex> get_profile!("noone")
      nil

  """
  def get_profile_by_slug(slug) do
    Repo.one(
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
  Creates a profile and adds its technology associations via a database
  transaction. Technologies that don't already exist in the database will be
  inserted as well.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}, assoc_technologies \\ []) do
    Multi.new()
    |> Multi.insert(:profile, Profile.changeset(%Profile{}, attrs))
    |> Multi.insert_all(:tech_upsert, Technology, assoc_technologies, on_conflict: :nothing)
    |> Multi.all(:technologies, Technologies.build_search_query(assoc_technologies))
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
  Updates a profile and its technology associations via a database transaction.

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
        assoc_technologies \\ []
      ) do
    Multi.new()
    |> Multi.update(:profile, Profile.changeset(profile, attrs))
    |> Multi.delete_all(
      :removed_technologies,
      from(pt in ProfileTechnology, where: pt.id in ^removed_profile_technology_ids)
    )
    |> Multi.insert_all(:tech_upsert, Technology, assoc_technologies, on_conflict: :nothing)
    |> Multi.all(:technologies, Technologies.build_search_query(assoc_technologies))
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
  Returns an `%Ecto.Changeset{}` for tracking resume changes.

  ## Examples

      iex> change_resume(resume)
      %Ecto.Changeset{data: %Resume{}}

  """
  def change_resume(%Resume{} = resume, attrs \\ %{}) do
    Resume.changeset(resume, attrs)
  end
end
