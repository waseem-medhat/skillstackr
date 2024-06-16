defmodule SkillstackrWeb.ProfilesLive do
  use SkillstackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "Profiles")

    {:ok, socket}
  end
end
