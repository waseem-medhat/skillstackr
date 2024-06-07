defmodule Skillstackr.Utils.SimpleIcons do
  @moduledoc """
  Functions used to pull and parse data from the SimpleIcons repository in
  order to create a JSON file with the icon data and SVGs.
  """

  def download_icons!(download_dir, repo_url) do
    if not File.exists?(download_dir) do
      case System.cmd("git", ["clone", repo_url, download_dir]) do
        {_, 0} -> :ok
        _ -> raise("error cloning")
      end
    end

    Path.join(download_dir, "icons")
  end

  defp build_map_entry(file_name, icon_map) do
    {:ok, file} = File.read(file_name)
    [_ | [name | _]] = Regex.run(~r/<title>(.+)<\/title>/, file)
    slug = String.replace(file_name, ~r/\.svg$/, "")

    icon_map
    |> put_in([:translation_map, slug], %{translation: name, common_key: name})
    |> put_in([:translation_map, name], %{translation: slug, common_key: name})
    |> put_in([:svg_map, name], file)
  end

  def parse_files() do
    File.ls!()
    |> Enum.reduce(%{translation_map: %{}, svg_map: %{}}, &build_map_entry/2)
  end
end

alias Skillstackr.Utils.SimpleIcons

json =
  Path.join(["priv", "utils", "simple-icons"])
  |> SimpleIcons.download_icons!("https://github.com/simple-icons/simple-icons.git")
  |> File.cd!(&SimpleIcons.parse_files/0)
  |> Jason.encode!()

File.write!(Path.join(["priv", "utils", "simpleicons_map.json"]), json)
