defmodule SkillstackrWeb.PageController do
  use SkillstackrWeb, :controller

  def home(%{assigns: %{current_account: nil}} = conn, _params) do
    conn
    |> assign(:page_title, "Welcome")
    |> render(:home, layout: false)
  end

  def home(conn, _params) do
    redirect(conn, to: "/profiles")
  end
end
