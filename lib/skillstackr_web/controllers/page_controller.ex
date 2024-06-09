defmodule SkillstackrWeb.PageController do
  use SkillstackrWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Welcome")
    |> render(:home, layout: false)
  end
end
