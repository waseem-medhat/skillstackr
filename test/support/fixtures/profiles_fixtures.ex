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
end
