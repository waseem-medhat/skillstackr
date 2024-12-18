defmodule Skillstackr.Technologies do
  @moduledoc """
  The Technologies context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Repo

  alias Skillstackr.Technologies.Technology

  @doc """
  Creates a technology.

  ## Examples

      iex> create_technology(%{field: value})
      {:ok, %Technology{}}

      iex> create_technology(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_technology(attrs \\ %{}) do
    %Technology{}
    |> Technology.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking technology changes.

  ## Examples

      iex> change_technology(technology)
      %Ecto.Changeset{data: %Technology{}}

  """
  def change_technology(%Technology{} = technology, attrs \\ %{}) do
    Technology.changeset(technology, attrs)
  end

  @doc """
  Converts a list of `Technology` structs to a map that categorizes
  technologies as "frontend", "backend", etc.

  ## Examples

      iex> list_to_map([])
      %{"frontend" => [], "backend" => [], "devops" => [], "devtools" => []}

      iex> list_to_map([%Technology{name: "Elixir", category: "backend"}])
      %{"backend" => ["Elixir"], "devops" => [], "devtools" => [], "frontend" => []}

  """
  def list_to_map(tech_list) when is_list(tech_list) do
    Enum.reduce(
      tech_list,
      %{"frontend" => [], "backend" => [], "devops" => [], "devtools" => []},
      fn %{name: name, category: category}, acc_map ->
        Map.put(acc_map, category, [name | acc_map[category]])
      end
    )
  end

  @doc """
  Converts a tech map to a list of "flat" maps which can be used as parameters
  for insertion/updates.

  ## Examples

      iex> map_to_list(%{"frontend" => [], "backend" => [], "devops" => [], "devtools" => []})
      []

      iex> map_to_list(%{"backend" => ["Elixir"], "devops" => [], "devtools" => [], "frontend" => []})
      [%{"name" => "Elixir", "category" => "backend"}]
      

  """
  def map_to_list(tech_map) when is_map(tech_map) do
    Enum.flat_map(
      tech_map,
      fn {category, tech_list} ->
        Enum.map(tech_list, fn tech_name -> %{name: tech_name, category: category} end)
      end
    )
  end

  @doc """
  Builds a query for finding the given list of technologies in the database.
  Its argument `technologies` is a list of maps.

  ## Examples

    iex> build_search_query([%{name: "Elixir", category: "backend"}])
    #Ecto.Query<>
  """
  def build_search_query(technologies) do
    base_query = from(t in Technology, where: false)

    Enum.reduce(technologies, base_query, fn %{name: name, category: category}, acc_query ->
      new_query =
        from t in Technology,
          where: t.name == ^name and t.category == ^category

      union_all(acc_query, ^new_query)
    end)
  end
end
