defmodule SkillstackrWeb.NewProfileLive do
  alias Skillstackr.Profiles
  alias Skillstackr.Profiles.Profile
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Profile")
      |> assign(:form, to_form(Profiles.change_profile(%Profile{})))
      |> assign(:technologies, %{
        "frontend" => [],
        "backend" => [],
        "devops" => [],
        "devtools" => []
      })
      |> assign(:tech_search_results, [])
      |> allow_upload(:resume, accept: ~w(.pdf))

    {:ok, socket}
  end

  def handle_event("search-technologies", params, socket) do
    results =
      case params["search-technologies"] do
        "" -> []
        str -> TechnologyComponents.get_names(str)
      end

    {:noreply, assign(socket, :tech_search_results, results)}
  end

  def handle_event("validate", params, socket) do
    new_form =
      Profiles.change_profile(%Profile{}, params["profile"])
      |> Map.put(:action, :validate)
      |> to_form(as: "profile")

    {:noreply, assign(socket, form: new_form)}
  end

  def handle_event("toggle-technology-" <> category, params, socket) do
    current_technologies = Map.get(socket.assigns.technologies, category)
    selected = params["value"]

    new_technologies =
      case Enum.find(current_technologies, &(&1 == selected)) do
        nil -> [selected | current_technologies]
        ^selected -> Enum.filter(current_technologies, &(&1 != selected))
      end

    {:noreply,
     assign(
       socket,
       :technologies,
       Map.put(socket.assigns.technologies, category, new_technologies)
     )}
  end

  def handle_event("save", params, socket) do
    profile_params =
      params
      |> Map.get("profile")
      |> Map.put("resume", get_resume_blob(socket))
      |> Map.put("technologies", get_technologies(socket))

    case Profiles.create_profile(profile_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile saved. Start adding some projects to it!")
         |> redirect(to: ~p"/profiles/#{profile_params["slug"]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp get_resume_blob(socket) do
    case socket.assigns.uploads.resume.entries do
      [] ->
        nil

      _ ->
        [resume_blob] =
          consume_uploaded_entries(socket, :resume, fn %{path: path}, _entry ->
            resume_blob = File.read!(path)
            {:ok, resume_blob}
          end)

        %{"blob" => resume_blob}
    end
  end

  defp get_technologies(socket) do
    socket.assigns.technologies
    |> Enum.flat_map(fn {category, tech_list} ->
      Enum.map(tech_list, &%{"name" => &1, "category" => category})
    end)
  end
end
