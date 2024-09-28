defmodule SkillstackrWeb.Components.SimpleiconsTest do
  use SkillstackrWeb.ConnCase, async: true

  alias SkillstackrWeb.Simpleicons

  describe "load_simpleicons_map/0" do
    @tag timeout: :infinity
    test "loads the icon map" do
      assert %{"Elixir" => %{slug: _, svg: _}} = Simpleicons.load_simpleicons_map()
    end
  end
end
