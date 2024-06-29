defmodule Brbackend.Adapter.Repo do
  use Ecto.Repo,
    otp_app: :brbackend,
    adapter: Ecto.Adapters.Postgres
end
