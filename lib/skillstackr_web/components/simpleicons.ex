defmodule SkillstackrWeb.Simpleicons do
  defp download_icons!(download_dir, repo_url) do
    unless File.exists?(download_dir) do
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

    slug =
      file_name
      |> Path.basename()
      |> String.replace(~r/\.svg$/, "")

    Map.put(icon_map, name, %{slug: slug, svg: file})
  end

  defp parse_files(path) do
    path
    |> File.ls!()
    |> Enum.map(fn file_name -> Path.absname(file_name, path) end)
    |> Enum.reduce(%{}, &build_map_entry/2)
  end

  def load_simpleicons_map() do
    assets_path = Path.join(["priv", "static", "assets"])
    unless File.exists?(assets_path), do: File.mkdir_p!(assets_path)

    Path.join([assets_path, "simple-icons"])
    |> download_icons!("https://github.com/simple-icons/simple-icons.git")
    |> parse_files()
  end
end
