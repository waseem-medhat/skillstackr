defmodule Skillstackr.ProfilesTest do
  use Skillstackr.DataCase

  alias Skillstackr.Profiles

  describe "profiles" do
    alias Skillstackr.Profiles.Profile

    import Skillstackr.ProfilesFixtures

    @invalid_attrs %{}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Profiles.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{}

      assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_attrs)
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{}

      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
      assert profile == Profiles.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end

  describe "projects" do
    alias Skillstackr.Profiles.Project

    import Skillstackr.ProfilesFixtures

    @invalid_attrs %{}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Profiles.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Profiles.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{}

      assert {:ok, %Project{} = project} = Profiles.create_project(valid_attrs)
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{}

      assert {:ok, %Project{} = project} = Profiles.update_project(project, update_attrs)
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_project(project, @invalid_attrs)
      assert project == Profiles.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Profiles.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Profiles.change_project(project)
    end
  end
end
