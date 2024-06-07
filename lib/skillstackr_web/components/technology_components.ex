defmodule TechnologyComponents do
  @moduledoc """
  Components and data needed for rendering technologies icons.

  The module uses a JSON file generated from parsing "Simple Icons" data
  ("https://simpleicons.org/"). If the JSON file doesn't exist, generate it
  by running `mix run simpleicons`.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @technology_map Path.join(["priv", "static", "assets", "simpleicons_map.json"])
                  |> File.read!()
                  |> Jason.decode!()

  def get_names() do
    @technology_map
    |> Map.get("svg_map")
    |> Map.keys()
  end

  attr :tech, :string

  def choice_button(%{:tech => tech} = assigns) do
    svg =
      @technology_map
      |> Map.get("svg_map")
      |> Map.get(tech)

    assigns = assign(assigns, :svg, svg)

    ~H"""
    <button
      type="button"
      class="form-tech-button py-3 px-4 flex items-center gap-x-2 text-sm font-semibold rounded-lg border border-transparent bg-blue-100 text-blue-800 hover:bg-blue-200 disabled:opacity-50 disabled:pointer-events-none dark:hover:bg-blue-900 dark:text-blue-400"
    >
      <div class="w-5 fill-blue-800">
        <%= raw(@svg) %>
      </div>
      <%= @tech %>
    </button>
    """
  end
end
