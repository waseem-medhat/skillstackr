defmodule SkillstackrWeb.ProfileController do
  alias Skillstackr.Technologies
  alias Skillstackr.{Accounts, Profiles}
  use SkillstackrWeb, :controller

  def show(conn, %{"slug" => slug}) do
    user = mock_user()

    %{profile: profile, technologies: technologies, jobs: jobs, projects: projects} =
      Profiles.get_profile_by_slug!(slug)

    editable =
      case conn.assigns.current_account do
        nil ->
          nil

        acc ->
          acc
          |> Accounts.get_account_slugs!()
          |> Enum.find_value(&(&1 == slug))
      end

    conn
    |> assign(:user, user)
    |> assign(:page_title, profile.full_name)
    |> assign(:profile, profile)
    |> assign(:editable, editable)
    |> assign(:tech_map, Technologies.list_to_map(technologies))
    |> assign(:jobs, jobs)
    |> assign(:projects, projects)
    |> render(:show)
  end

  def get_resume(conn, %{"slug" => slug}) do
    resume_blob = Profiles.get_resume_blob!(slug)

    conn
    |> put_resp_content_type("application/pdf")
    |> send_resp(200, resume_blob)
  end

  defp mock_user() do
    projects = [
      %{
        id: 1,
        title: "Cool Project",
        cover_url:
          "https://images.unsplash.com/photo-1680868543815-b8666dba60f7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2532&q=80",
        technologies: [:typescript, :svelte, :tailwindcss, :supabase],
        description:
          "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
        code_url: "https://github.com/waseem-medhat/skillstackr",
        site_url: "https://github.com/waseem-medhat/skillstackr"
      },
      %{
        id: 2,
        title: "Awesome Project",
        cover_url:
          "https://images.unsplash.com/photo-1680868543815-b8666dba60f7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2532&q=80",
        technologies: [:elixir, :phoenixframework, :tailwindcss, :postgresql, :docker],
        description:
          "Ipsum sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
        code_url: "https://github.com/waseem-medhat/skillstackr",
        site_url: "https://github.com/waseem-medhat/skillstackr"
      }
    ]

    experience = [
      %{
        id: 1,
        title: "Senior Backend Developer",
        company: "ACME",
        description:
          "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
        years: 2
      },
      %{
        id: 2,
        title: "Backend Developer",
        company: "ABC",
        description:
          "ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
        years: 2
      },
      %{
        id: 3,
        title: "Frontend Developer",
        company: "LOL",
        description:
          "sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
        years: 1
      }
    ]

    total_exp_years =
      experience
      |> Enum.map(fn e -> e.years end)
      |> Enum.sum()

    %{
      photo_url:
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
      projects: projects,
      experience: experience,
      total_exp_years: total_exp_years
    }
  end
end
