defmodule Svdcomp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :inets.start()
    :ssl.start()
    # List all child processes to be supervised
    children = [
      {Plug.Cowboy, scheme: :http, plug: Bumper.Router, options: [port: 8050]}
      # Starts a worker by calling: Svdcomp.Worker.start_link(arg)
      # {Svdcomp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Svdcomp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
