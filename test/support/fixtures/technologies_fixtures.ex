defmodule Skillstackr.TechnologiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skillstackr.Technologies` context.
  """

  @doc """
  Generate a technology.
  """
  def technology_fixture(attrs \\ %{}) do
    {:ok, technology} =
      attrs
      |> Enum.into(%{

      })
      |> Skillstackr.Technologies.create_technology()

    technology
  end
end
