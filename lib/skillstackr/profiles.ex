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

  @bucket_name System.get_env("S3_BUCKET_NAME", "")

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
  def create_profile(attrs \\ %{}, assoc_technologies \\ [], resume_blob \\ <<>>) do
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
    |> Multi.run(:resume_upload, fn _repo, %{profile: profile} ->
      ExAws.S3.put_object(@bucket_name, "#{profile.slug}/resume.pdf", resume_blob)
      |> ExAws.request()
    end)
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
      fn %{profile: profile, technologies: new_technologies} ->
        Enum.map(new_technologies, fn t -> %{profile_id: profile.id, technology_id: t.id} end)
      end,
      on_conflict: :nothing
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
    Multi.new()
    |> Multi.delete(:profile, profile)
    |> Multi.run(:resume_upload, fn _repo, _changes ->
      stream =
        ExAws.S3.list_objects(@bucket_name, prefix: profile.slug)
        |> ExAws.stream!()
        |> Stream.map(& &1.key)

      ExAws.S3.delete_all_objects(@bucket_name, stream)
      |> ExAws.request()
    end)
    |> Repo.transaction()
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

  @doc """
  Fetches a single resume using the given profile slug.
  """
  def get_resume_blob!(slug) do
    ExAws.S3.get_object(@bucket_name, "#{slug}/resume.pdf")
    |> ExAws.request!()
    |> Map.get(:body)
  end
end
