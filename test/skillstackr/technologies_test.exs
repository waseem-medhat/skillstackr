defmodule Skillstackr.TechnologiesTest do
  use Skillstackr.DataCase

  alias Skillstackr.Technologies

  describe "technologies" do
    alias Skillstackr.Technologies.Technology

    import Skillstackr.TechnologiesFixtures

    @invalid_attrs %{name: ""}
    @valid_attrs %{name: "React", category: "frontend"}

    test "create_technology/1 with valid data creates a technology" do
      assert {:ok, %Technology{}} = Technologies.create_technology(@valid_attrs)
    end

    test "create_technology/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Technologies.create_technology(@invalid_attrs)
    end

    test "change_technology/1 returns a technology changeset" do
      technology = technology_fixture(@valid_attrs)
      assert %Ecto.Changeset{} = Technologies.change_technology(technology)
    end
  end
end
