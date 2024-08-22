defmodule Skillstackr.ProfilesTest do
  use Skillstackr.DataCase

  alias Skillstackr.Profiles

  describe "profiles" do
    alias Skillstackr.Profiles.Profile

    import Skillstackr.AccountsFixtures
    import Skillstackr.ProfilesFixtures

    @invalid_attrs %{full_name: ""}

    defp valid_profile_fixture(account_id) do
      profile_fixture(%{account_id: account_id, full_name: "John Doe", slug: "johndoe"})
    end

    test "get_profile_by_slug/1 returns the profile with given slug" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)

      assert Profiles.get_profile_by_slug(profile.slug).id == profile.id
    end

    test "create_profile/1 with valid data creates a profile" do
      %{id: account_id} = account_fixture()
      valid_attrs = %{account_id: account_id, full_name: "John Doe", slug: "johndoe"}

      assert {:ok, %{profile: %Profile{}}} = Profiles.create_profile(valid_attrs)
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, :profile, %Ecto.Changeset{}, %{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)
      update_attrs = %{}

      assert {:ok, %{profile: %Profile{}}} = Profiles.update_profile(profile, update_attrs)
    end

    test "update_profile/2 with invalid data returns error changeset" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)

      assert {:error, :profile, %Ecto.Changeset{}, %{}} =
               Profiles.update_profile(profile, @invalid_attrs)

      # assert profile == Profiles.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)

      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert is_nil(Profiles.get_profile_by_slug(profile.slug))
    end

    test "change_profile/1 returns a profile changeset" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)

      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end

  describe "resumes" do
    alias Skillstackr.Profiles.Resume

    import Skillstackr.ProfilesFixtures

    test "create_resume/1 with valid data creates a resume" do
      valid_attrs = %{blob: <<0>>}

      assert {:ok, %Resume{} = resume} = Profiles.create_resume(valid_attrs)
      assert resume.blob == <<0>>
    end

    test "create_resume/1 with invalid data returns error changeset" do
      invalid_attrs = %{blob: <<0::size(5 * 1024 * 1024 + 100)-unit(8)>>}
      assert {:error, %Ecto.Changeset{}} = Profiles.create_resume(invalid_attrs)
    end

    test "change_resume/1 returns a resume changeset" do
      resume = resume_fixture()
      assert %Ecto.Changeset{} = Profiles.change_resume(resume)
    end
  end
end
