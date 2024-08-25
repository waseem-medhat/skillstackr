defmodule Skillstackr.JobsTest do
  use Skillstackr.DataCase

  alias Skillstackr.Jobs

  describe "jobs" do
    alias Skillstackr.Jobs.Job
    import Skillstackr.{JobsFixtures, AccountsFixtures, ProfilesFixtures}

    @invalid_attrs %{experience_years: -1}

    @valid_attrs %{
      title: "Senior Bikeshedder",
      company: "The Bikeshedding Company",
      experience_years: 4
    }

    defp valid_profile_fixture(account_id) do
      profile_fixture(%{account_id: account_id, full_name: "John Doe", slug: "johndoe"})
    end

    test "get_job/1 returns the job with given id" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()

      assert Jobs.get_job(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      account = account_fixture()
      attrs = Map.put(@valid_attrs, :account_id, account.id)

      assert {:ok, %{new_job: %Job{}}} = Jobs.create_job(attrs)
    end

    test "create_job/1 associates profiles with a created job" do
      %{id: account_id} = account_fixture()
      profile = valid_profile_fixture(account_id)

      attrs = Map.put(@valid_attrs, :account_id, account_id)
      {:ok, %{new_job: job}} = Jobs.create_job(attrs, [profile])

      assoc_profiles =
        Jobs.get_job(job.id).profiles_jobs
        |> Enum.map(fn pj -> pj.profile end)

      assert assoc_profiles == [profile]
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, :new_job, %Ecto.Changeset{}, %{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/4 with valid data updates the job" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()
      update_attrs = %{}

      assert {:ok, %{job: %Job{}}} = Jobs.update_job(job, update_attrs)
    end

    test "update_job/4 with invalid data returns error changeset" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()

      assert {:error, :job, %Ecto.Changeset{}, %{}} = Jobs.update_job(job, @invalid_attrs)
      assert job == Jobs.get_job(job.id)
    end

    test "delete_job/1 deletes the job" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()

      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert is_nil(Jobs.get_job(job.id))
    end

    test "change_job/1 returns a job changeset" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()

      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
