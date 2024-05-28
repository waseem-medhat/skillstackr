defmodule SkillstackrWeb.ProfileController do
  use SkillstackrWeb, :controller

  defp get_user(id) do
    links = [
      %{site: :github, url: "https://github.com/waseem-medhat"},
      %{site: :linkedin, url: "https://linkedin.com/in/waseem-medhat"},
      %{site: :website, url: "https://linkedin.com/in/waseem-medhat"},
      %{site: :resume, url: "https://linkedin.com/in/waseem-medhat"}
    ]

    %{
      name: "John Doe",
      id: id,
      links: links
    }
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:user, get_user(id))
    |> render(:show)
  end
end
