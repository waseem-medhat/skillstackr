defmodule SkillstackrWeb.ProfileController do
  alias Skillstackr.Profiles.Profile
  alias Skillstackr.Profiles
  use SkillstackrWeb, :controller

  def show(conn, %{"id" => id}) do
    user = get_user(id)
    profile = Profiles.get_profile_by_slug!(id)

    conn
    |> assign(:user, user)
    |> assign(:profile, profile)
    |> assign(:page_title, user.name)
    |> render(:show)
  end

  def new(conn, _params) do
    conn
    |> assign(:page_title, "New Profile")
    |> assign(:changeset, Profiles.change_profile(%Profile{}))
    |> render(:new)
  end

  def create(conn, %{"profile" => profile}) do
    case Profiles.create_profile(profile) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Profile saved. Start adding some projects to it!")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  defp get_user(id) do
    links = [
      %{id: 1, site: :github, url: "https://github.com/waseem-medhat"},
      %{id: 2, site: :linkedin, url: "https://linkedin.com/in/waseem-medhat"},
      %{id: 3, site: :website, url: "https://wipdev.netlify.app"},
      %{id: 4, site: :resume, url: "https://linkedin.com/in/waseem-medhat"}
    ]

    summary =
      "Highly motivated Full-Stack Developer with a strong foundation in front-end and back-end technologies. Proven ability to design, develop, and deploy user-friendly web applications. Eager to learn and contribute to a fast-paced development environment."

    skills = %{
      frontend: [:typescript, :react, :svelte, :htmx],
      backend: [:elixir, :phoenixframework, :go],
      devops: [:ubuntu, :docker],
      dev_tools: [:visualstudiocode, :neovim, :tmux]
    }

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
      name: "John Doe",
      photo_url:
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
      summary: summary,
      id: id,
      links: links,
      skills: skills,
      projects: projects,
      experience: experience,
      total_exp_years: total_exp_years
    }
  end
end
