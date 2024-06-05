defmodule Skillstackr.Technologies do
  @moduledoc """
  The Technologies context.
  """

  import Ecto.Query, warn: false
  alias Skillstackr.Repo

  alias Skillstackr.Technologies.Technology

  @doc """
  Returns the list of technologies.

  ## Examples

      iex> list_technologies()
      [%Technology{}, ...]

  """
  def list_technologies do
    Repo.all(Technology)
  end

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
end
