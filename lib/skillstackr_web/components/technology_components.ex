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

  def name_to_svg(tech_name) do
    get_in(@technology_map, ["svg_map", tech_name])
  end

  def name_to_slug(tech_name) do
    get_in(@technology_map, ["translation_map", tech_name, "translation"])
  end

  def get_names(search_str \\ "") do
    search_str = String.downcase(search_str)

    @technology_map
    |> Map.get("svg_map")
    |> Map.keys()
    |> Enum.reduce([], fn s, acc ->
      s_downcase = String.downcase(s)

      cond do
        search_str == s_downcase ->
          [s | acc]

        String.contains?(s_downcase, search_str) ->
          case acc do
            [] -> [s | acc]
            [hd | tl] -> [hd | [s | tl]]
          end

        true ->
          acc
      end
    end)
  end

  attr :tech, :string

  def choice_button(%{:tech => tech_name} = assigns) do
    assigns = assign(assigns, :svg, name_to_svg(tech_name))

    ~H"""
    <div
      value={@tech}
      class="w-full py-3 px-4 flex items-center gap-x-2 text-sm font-semibold rounded-lg border border-transparent bg-blue-100 text-blue-800"
    >
      <section class="flex-grow flex items-center gap-2">
        <div class="w-5 fill-blue-800 pointer-events-none"><%= raw(@svg) %></div>
        <span class="tech-text pointer-events-none"><%= @tech %></span>
      </section>
      <section class="flex items-center gap-2">
        <span class="font-light text-blue-600">Add to:</span>
        <button type="button" phx-click="toggle-technology-frontend" value={@tech}>
          Front-end
        </button>
        <span class="font-light text-blue-600">|</span>
        <button type="button" phx-click="toggle-technology-backend" value={@tech}>
          Back-end
        </button>
        <span class="font-light text-blue-600">|</span>
        <button type="button" phx-click="toggle-technology-devops" value={@tech}>
          DevOps
        </button>
        <span class="font-light text-blue-600">|</span>
        <button type="button" phx-click="toggle-technology-devtools" value={@tech}>
          Dev tools
        </button>
      </section>
    </div>
    """
  end

  attr :tech, :string
  attr :size, :integer, default: 25

  def tech_badge(assigns) do
    ~H"""
    <img src={"https://cdn.simpleicons.org/#{name_to_slug(@tech)}"} width={@size} alt={"#{@tech}"} />
    """
  end
end
