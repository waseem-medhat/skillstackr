defmodule SkillstackrWeb.NewProfileLive do
  use SkillstackrWeb, :live_view

  def render(assigns) do
    ~H"""
    Hello new profile
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
