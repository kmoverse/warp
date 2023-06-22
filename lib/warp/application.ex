defmodule Warp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WarpWeb.Telemetry,
      # Start the Ecto repository
      Warp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Warp.PubSub},
      # Start Finch
      {Finch, name: Warp.Finch},
      # Start the Endpoint (http/https)
      WarpWeb.Endpoint
      # Start a worker by calling: Warp.Worker.start_link(arg)
      # {Warp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Warp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WarpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
