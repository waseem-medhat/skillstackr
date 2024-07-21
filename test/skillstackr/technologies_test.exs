defmodule Skillstackr.TechnologiesTest do
  use Skillstackr.DataCase

  alias Skillstackr.Technologies

  describe "technologies" do
    alias Skillstackr.Technologies.Technology

    import Skillstackr.TechnologiesFixtures

    @invalid_attrs %{}

    test "get_technology!/1 returns the technology with given id" do
      technology = technology_fixture()
      assert Technologies.get_technology!(technology.id) == technology
    end

    test "create_technology/1 with valid data creates a technology" do
      valid_attrs = %{}

      assert {:ok, %Technology{} = technology} = Technologies.create_technology(valid_attrs)
    end

    test "create_technology/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Technologies.create_technology(@invalid_attrs)
    end

    test "update_technology/2 with valid data updates the technology" do
      technology = technology_fixture()
      update_attrs = %{}

      assert {:ok, %Technology{} = technology} = Technologies.update_technology(technology, update_attrs)
    end

    test "update_technology/2 with invalid data returns error changeset" do
      technology = technology_fixture()
      assert {:error, %Ecto.Changeset{}} = Technologies.update_technology(technology, @invalid_attrs)
      assert technology == Technologies.get_technology!(technology.id)
    end

    test "delete_technology/1 deletes the technology" do
      technology = technology_fixture()
      assert {:ok, %Technology{}} = Technologies.delete_technology(technology)
      assert_raise Ecto.NoResultsError, fn -> Technologies.get_technology!(technology.id) end
    end

    test "change_technology/1 returns a technology changeset" do
      technology = technology_fixture()
      assert %Ecto.Changeset{} = Technologies.change_technology(technology)
    end
  end
end
