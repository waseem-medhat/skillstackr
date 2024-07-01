defmodule SkillstackrWeb.TechnologyComponents do
  @moduledoc """
  Components and data needed for rendering technologies icons.

  The module uses a JSON file generated from parsing "Simple Icons" data
  ("https://simpleicons.org/"). If the JSON file doesn't exist, it will
  be generated.
  """
  alias SkillstackrWeb.Simpleicons
  use Phoenix.Component
  import Phoenix.HTML
  import SkillstackrWeb.CoreComponents

  @technology_map Simpleicons.load_simpleicons_map()

  def name_to_svg(tech_name), do: get_in(@technology_map, [tech_name, :svg])
  def name_to_slug(tech_name), do: get_in(@technology_map, [tech_name, :slug])

  def get_names(search_str \\ "") do
    search_str = String.downcase(search_str)

    @technology_map
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
  attr :size, :integer, default: 25
  attr :class, :string, default: ""

  def tech_badge(assigns) do
    ~H"""
    <div class="hs-tooltip inline-block">
      <button type="button" class="hs-tooltip-toggle cursor-default">
        <img
          class={["hover:brightness-[125%] transition", @class]}
          src={"https://cdn.simpleicons.org/#{name_to_slug(@tech)}"}
          width={@size}
          alt={"#{@tech}"}
        />
        <span
          class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible opacity-0 transition-opacity inline-block absolute invisible z-10 py-1 px-2 bg-gray-900 text-xs font-medium text-white rounded shadow-sm dark:bg-neutral-700"
          role="tooltip"
        >
          <%= @tech %>
        </span>
      </button>
    </div>
    """
  end

  @doc """
  Renders a search box for technologies. Each technology can be added as either
  frontend, backend, DevOps, or dev tools.

  The associated `result_button` component can trigger any of four events
  depending on the category chosen by the user:
  - `"toggle-technology-frontend"`
  - `"toggle-technology-backend"`
  - `"toggle-technology-devops"`
  - `"toggle-technology-devtools"`
  """
  attr :tech_search_results, :list, required: true

  def search_box(assigns) do
    ~H"""
    <section>
      <.input
        type="search"
        name="search-technologies"
        id="search-technologies"
        placeholder="Start searching"
        phx-change="search-technologies"
        phx-debounce="300"
        value=""
      />

      <div class="h-36 overflow-y-auto my-2 p-2 border dark:border-neutral-700 border-gray-200 rounded-lg">
        <div class="flex items-center justify-center gap-1 flex-wrap">
          <.result_button :for={tech <- @tech_search_results} tech={tech} />
        </div>
      </div>
    </section>
    """
  end

  attr :tech, :string

  defp result_button(%{:tech => tech_name} = assigns) do
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
end
