defmodule Skillstackr.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skillstackr.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{

      })
      |> Skillstackr.Profiles.create_profile()

    profile
  end

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{

      })
      |> Skillstackr.Profiles.create_project()

    project
  end

  @doc """
  Generate a resume.
  """
  def resume_fixture(attrs \\ %{}) do
    {:ok, resume} =
      attrs
      |> Enum.into(%{
        blob: "some blob"
      })
      |> Skillstackr.Profiles.create_resume()

    resume
  end
end
