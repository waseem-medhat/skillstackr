defmodule Skillstackr.Repo do
  use Ecto.Repo,
    otp_app: :skillstackr,
    adapter: Ecto.Adapters.Postgres
end
