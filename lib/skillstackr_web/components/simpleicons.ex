defmodule SkillstackrWeb.Simpleicons do
  @moduledoc """
  Functions for downloading and parsing the Simple Icons data.

  The [Simple Icons](https://github.com/simple-icons/simple-icons) API works by
  using a URL with a slug to get the corresponding icon. But there is no direct
  way of obtaining the title as well.

  So the purpose of this module is to download and parse the SVG files from the
  Simple Icons source in order to provide the complete data to the application.

  """

  @doc """
  Load the Simple Icons data map.

  The function clones the Simple Icons repo if it doesn't already exist
  locally, then parses the SVGs for the relevant data into a map whose
  keys are full technology names and the values are maps, each with the
  structure `%{slug: "tech_slug", svg: "svg_string"}`

  """
  def load_simpleicons_map() do
    assets_path = Path.join(["priv", "static", "assets"])
    unless File.exists?(assets_path), do: File.mkdir_p!(assets_path)

    Path.join([assets_path, "simple-icons"])
    |> download_icons!("https://github.com/simple-icons/simple-icons.git")
    |> parse_files()
  end

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

  defp build_map_entry(file_name) do
    file = File.read!(file_name)
    name = parse_name(file)

    slug =
      file_name
      |> Path.basename()
      |> String.replace(~r/\.svg$/, "")

    %{name => %{slug: slug, svg: file}}
  end

  defp parse_files(path) do
    path
    |> File.ls!()
    |> Enum.filter(fn file_name -> file_name =~ ~r/.*\.svg$/ and !(file_name =~ "-") end)
    |> Enum.map(fn file_name ->
      file_name = Path.absname(file_name, path)
      Task.async(fn -> build_map_entry(file_name) end)
    end)
    |> Enum.reduce(%{}, fn task, map ->
      map_entry = Task.await(task)
      Map.merge(map, map_entry)
    end)
  end
end
