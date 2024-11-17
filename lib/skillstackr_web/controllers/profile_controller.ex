defmodule SkillstackrWeb.ProfileController do
  alias Skillstackr.Profiles
  use SkillstackrWeb, :controller

  def get_resume(conn, %{"slug" => slug}) do
    resume_blob = Profiles.get_resume_blob!(slug)

    conn
    |> put_resp_content_type("application/pdf")
    |> send_resp(200, resume_blob)
  end

  def get_photo(conn, %{"slug" => slug}) do
    case Profiles.get_photo_blob(slug) do
      {:ok, %{body: photo_blob}} ->
        conn
        |> put_resp_content_type("image/jpg")
        |> send_resp(200, photo_blob)

      {:error, {:http_error, 404, _}} ->
        conn
        |> send_resp(404, "Not found")
    end
  end
end
