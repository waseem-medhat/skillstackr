defmodule Mix.Tasks.Simpleicons do
  @moduledoc """
  Pulls and parses the data from the SimpleIcons repository in order to create
  a JSON file with the icon data and SVGs.
  """
  use Mix.Task

  defp download_icons!(download_dir, repo_url) do
    if not File.exists?(download_dir) do
      IO.puts("Icon repo clone not found, cloning...")
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

  defp parse_files() do
    File.ls!()
    |> Enum.reduce(%{translation_map: %{}, svg_map: %{}}, &build_map_entry/2)
  end

  def run([]) do
    assets_path = Path.join(["priv", "static", "assets"])

    json =
      Path.join(assets_path, "simple-icons")
      |> download_icons!("https://github.com/simple-icons/simple-icons.git")
      |> File.cd!(&parse_files/0)
      |> Jason.encode!()

    Path.join(assets_path, "simpleicons_map.json")
    |> File.write!(json)

    IO.puts("Done!")
  end
end
