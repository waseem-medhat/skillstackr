defmodule SkillstackrWeb.ProfileController do
  use SkillstackrWeb, :controller

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end
end
