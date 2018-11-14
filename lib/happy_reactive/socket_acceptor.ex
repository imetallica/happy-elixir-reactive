defmodule HappyReactive.SocketAcceptor do
  use GenStage
  require Logger

  @port 5000

  def start_link(args, opts) do
    GenStage.start_link(__MODULE__, args, opts)
  end

  def init(_args) do
    Logger.debug("Initializing socket...")
    {:ok, socket} = :gen_udp.open(@port, [:binary, active: :once, reuseaddr: true])
    Logger.info("Listening to UDP socket #{@port}.")

    {:producer, %{socket: socket}}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  def handle_info({:udp, _port, _addr, _ancdata, data}, state) do
    Logger.info("Hey, me #{inspect(self())} received: #{inspect(data)}.")

    :ok = :inet.setopts(state.socket, active: :once)
    {:noreply, [data], state}
  end
end
