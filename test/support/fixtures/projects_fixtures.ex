defmodule Skillstackr.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skillstackr.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, %{new_project: project}} =
      attrs
      |> Enum.into(%{})
      |> Skillstackr.Projects.create_project()

    project
  end
end
