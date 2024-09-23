defmodule Skillstackr.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skillstackr.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, %{profile: profile}} =
      attrs
      |> Enum.into(%{})
      |> Skillstackr.Profiles.create_profile([], "test_blob")

    profile
  end
end
