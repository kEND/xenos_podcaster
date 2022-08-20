defmodule XenosPodcaster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      XenosPodcaster.Repo,
      # Start the Telemetry supervisor
      XenosPodcasterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: XenosPodcaster.PubSub},
      # Start the Endpoint (http/https)
      XenosPodcasterWeb.Endpoint
      # Start a worker by calling: XenosPodcaster.Worker.start_link(arg)
      # {XenosPodcaster.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XenosPodcaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XenosPodcasterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
