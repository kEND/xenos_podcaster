defmodule XenosPodcaster.Repo do
  use Ecto.Repo,
    otp_app: :xenos_podcaster,
    adapter: Ecto.Adapters.Postgres
end
