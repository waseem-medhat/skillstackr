defmodule SkillstackrWeb.ProfileController do
  use SkillstackrWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:id, id)
    |> render(:show)
  end
end
