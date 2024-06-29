defmodule Brbackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Brbackend.Adapter.Repo,
      BrbackendWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:brbackend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Brbackend.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Brbackend.Finch},
      # Start a worker by calling: Brbackend.Worker.start_link(arg)
      # {Brbackend.Worker, arg},
      # Start to serve requests, typically the last entry
      BrbackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Brbackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrbackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
