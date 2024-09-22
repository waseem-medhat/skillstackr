defmodule Skillstackr.JobsTest do
  use Skillstackr.DataCase

  alias Skillstackr.Jobs

  describe "jobs" do
    import Skillstackr.{JobsFixtures, AccountsFixtures}

    @valid_attrs %{
      title: "Senior Bikeshedder",
      company: "The Bikeshedding Company",
      experience_years: 4
    }

    test "change_job/1 returns a job changeset" do
      account = account_fixture()
      job = @valid_attrs |> Map.put(:account_id, account.id) |> job_fixture()

      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
