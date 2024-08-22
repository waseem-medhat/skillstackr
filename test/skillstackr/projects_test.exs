defmodule Skillstackr.ProjectsTest do
  use Skillstackr.DataCase

  alias Skillstackr.Projects

  describe "projects" do
    alias Skillstackr.Projects.Project

    import Skillstackr.ProjectsFixtures
    import Skillstackr.AccountsFixtures

    @invalid_attrs %{title: ""}

    test "get_project/1 returns the project with given id" do
      %{id: account_id} = account_fixture()
      project = project_fixture(%{title: "My Project", account_id: account_id})

      assert Projects.get_project(project.id).id == project.id
    end

    test "create_project/1 with valid data creates a project" do
      %{id: account_id} = account_fixture()

      assert {:ok, %{new_project: %Project{}}} =
               Projects.create_project(%{title: "My Project", account_id: account_id})
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, :new_project, %Ecto.Changeset{}, %{}} =
               Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      %{id: account_id} = account_fixture()
      project = project_fixture(%{title: "My Project", account_id: account_id})
      update_attrs = %{}

      assert {:ok, %{project: %Project{}}} = Projects.update_project(project, update_attrs)
    end

    test "update_project/2 with invalid data returns error changeset" do
      %{id: account_id} = account_fixture()
      project = project_fixture(%{title: "My Project", account_id: account_id})

      assert {:error, :project, %Ecto.Changeset{}, %{}} =
               Projects.update_project(project, @invalid_attrs)

      # assert project == Projects.get_project(project.id)
    end

    test "delete_project/1 deletes the project" do
      %{id: account_id} = account_fixture()
      project = project_fixture(%{title: "My Project", account_id: account_id})

      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert is_nil(Projects.get_project(project.id))
    end

    test "change_project/1 returns a project changeset" do
      %{id: account_id} = account_fixture()
      project = project_fixture(%{title: "My Project", account_id: account_id})

      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
