defmodule Skillstackr.ProfilesTest do
  use Skillstackr.DataCase

  alias Skillstackr.Profiles

  describe "profiles" do
    alias Skillstackr.Profiles.Profile

    import Skillstackr.ProfilesFixtures

    @invalid_attrs %{}

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Profiles.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{}

      assert {:ok, %Profile{}} = Profiles.create_profile(valid_attrs)
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{}

      assert {:ok, %Profile{}} = Profiles.update_profile(profile, update_attrs)
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

  describe "resumes" do
    alias Skillstackr.Profiles.Resume

    import Skillstackr.ProfilesFixtures

    @invalid_attrs %{blob: nil}

    test "create_resume/1 with valid data creates a resume" do
      valid_attrs = %{blob: "some blob"}

      assert {:ok, %Resume{} = resume} = Profiles.create_resume(valid_attrs)
      assert resume.blob == "some blob"
    end

    test "create_resume/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_resume(@invalid_attrs)
    end

    test "change_resume/1 returns a resume changeset" do
      resume = resume_fixture()
      assert %Ecto.Changeset{} = Profiles.change_resume(resume)
    end
  end
end
