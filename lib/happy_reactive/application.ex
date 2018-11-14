defmodule HappyReactive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  alias HappyReactive.StageHandler
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: HappyReactive.Worker.start_link(arg)
      # {HappyReactive.Worker, arg},
      {StageHandler, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HappyReactive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
