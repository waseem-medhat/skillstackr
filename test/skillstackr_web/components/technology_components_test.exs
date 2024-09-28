defmodule SkillstackrWeb.Components.TechnologyComponentsTest do
  use SkillstackrWeb.ConnCase, async: true
  doctest SkillstackrWeb.TechnologyComponents

  alias SkillstackrWeb.TechnologyComponents

  describe "name_to_svg/1" do
    test "returns an SVG string" do
      assert "<svg" <> _ = TechnologyComponents.name_to_svg("Elixir")
    end
  end

  describe "name_to_slug/1" do
    test "returns a tech slug" do
      assert "elixir" == TechnologyComponents.name_to_slug("Elixir")
    end
  end

  describe "find_tech_names/1" do
    test "doesn't search with empty input" do
      assert [] == TechnologyComponents.find_tech_names("")
    end

    test "handles partial matches (case-insensitive)" do
      search_result = TechnologyComponents.find_tech_names("sql")
      assert "SQLite" in search_result
      assert "PostgreSQL" in search_result
    end

    test "handles exact matches" do
      assert ["Go" | _] = TechnologyComponents.find_tech_names("go")
      assert ["R" | _] = TechnologyComponents.find_tech_names("R")
    end
  end
end
