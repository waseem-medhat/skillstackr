defmodule SkillstackrWeb.ProfileHTML do
  @moduledoc """
  This module contains pages rendered by ProfileController.

  See the `profile_html` directory for all templates available.
  """
  use SkillstackrWeb, :html

  embed_templates "profile_html/*"
end

