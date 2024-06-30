defmodule SkillstackrWeb.Simpleicons do
  defp download_icons!(download_dir, repo_url) do
    if not File.exists?(download_dir) do
      IO.puts("Icon repo clone not found, cloning...")

      case System.cmd("git", ["clone", "-b", "master", repo_url, download_dir]) do
        {_, 0} -> :ok
        _ -> raise("error cloning")
      end
    end

    Path.join(download_dir, "icons")
  end

  defp parse_name(contents, title \\ nil)

  defp parse_name(<<"<title>", char::utf8, rest::binary>>, _title),
    do: parse_name(rest, <<char::utf8>>)

  defp parse_name(<<"</title>", _rest::binary>>, title),
    do: title

  defp parse_name(<<_char::utf8, rest::binary>>, nil),
    do: parse_name(rest, nil)

  defp parse_name(<<char::utf8, rest::binary>>, title),
    do: parse_name(rest, <<title::bitstring, char::utf8>>)

  defp build_map_entry(file_name, icon_map) do
    file = File.read!(file_name)
    name = parse_name(file)
    slug = String.replace(file_name, ~r/\.svg$/, "")

    Map.put(icon_map, name, %{slug: slug, svg: file})
  end

  defp parse_files(), do: Enum.reduce(File.ls!(), %{}, &build_map_entry/2)

  def load_simpleicons_map() do
    assets_path = Path.join(["priv", "static", "assets"])
    json_path = Path.join(assets_path, "simpleicons_map.json")

    unless File.exists?(json_path) do
      json =
        Path.join("/tmp", "simple-icons")
        |> download_icons!("https://github.com/simple-icons/simple-icons.git")
        |> File.cd!(&parse_files/0)
        |> Jason.encode!()

      File.write!(json_path, json)
    end

    json_path
    |> File.read!()
    |> Jason.encode!()
  end
end
