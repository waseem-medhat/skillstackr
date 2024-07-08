defmodule Skillstackr.Technologies do
  @moduledoc """
  The Technologies context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Repo

  alias Skillstackr.Technologies.Technology

  @doc """
  Gets a single technology.

  Raises `Ecto.NoResultsError` if the Technology does not exist.

  ## Examples

      iex> get_technology!(123)
      %Technology{}

      iex> get_technology!(456)
      ** (Ecto.NoResultsError)

  """
  def get_technology!(id), do: Repo.get!(Technology, id)

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
  Updates a technology.

  ## Examples

      iex> update_technology(technology, %{field: new_value})
      {:ok, %Technology{}}

      iex> update_technology(technology, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_technology(%Technology{} = technology, attrs) do
    technology
    |> Technology.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a technology.

  ## Examples

      iex> delete_technology(technology)
      {:ok, %Technology{}}

      iex> delete_technology(technology)
      {:error, %Ecto.Changeset{}}

  """
  def delete_technology(%Technology{} = technology) do
    Repo.delete(technology)
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
        Enum.map(tech_list, fn tech_name -> %{"name" => tech_name, "category" => category} end)
      end
    )
  end
end
