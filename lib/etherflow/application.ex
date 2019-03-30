defmodule Etherflow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)},      
      %{
        id: EtherflowWeb.Endpoint,
        start: {EtherflowWeb.Endpoint, :start_link, []}
        },
      # Starts a worker by calling: Etherflow.Worker.start_link(arg)
      # {Etherflow.start, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Etherflow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EtherflowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
