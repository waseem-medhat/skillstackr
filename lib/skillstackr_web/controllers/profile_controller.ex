defmodule SkillstackrWeb.ProfileController do
  alias Skillstackr.Profiles
  use SkillstackrWeb, :controller

  def get_resume(conn, %{"slug" => slug}) do
    resume_blob = Profiles.get_resume_blob!(slug)

    conn
    |> put_resp_content_type("application/pdf")
    |> send_resp(200, resume_blob)
  end
end
