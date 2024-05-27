defmodule SkillstackrWeb.PageController do
  use SkillstackrWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home, layout: false)
  end
end
