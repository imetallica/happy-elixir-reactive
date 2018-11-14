defmodule HappyReactive.StageHandler do
  @moduledoc """
  The stage handler is just a supervisor that's responsible
  to distribute the message load towards many GenStage producers.
  """
  use Supervisor

  def start_link(params) do
    Supervisor.start_link(__MODULE__, params, name: __MODULE__)
  end

  @doc """
  Build your pipeline from here.
  """
  def flow_to_handle() do
    [HappyReactive.SocketAcceptor]
    |> Flow.from_stages()
    |> Flow.map(fn x -> IO.inspect(x, label: "From FLOW") end)
    |> Flow.map(&String.trim(&1, "\n"))
    |> Flow.flat_map(&String.codepoints/1)
    |> Flow.partition()
    |> Flow.map(&IO.inspect(&1, label: "Partition 2"))
    |> Flow.reduce(fn -> %{} end, fn element, acc ->
      Map.update(acc, element, 1, &(&1 + 1))
    end)
    |> Flow.emit(:state)
  end

  def init(_params) do
    children = [
      %{
        id: 0,
        start:
          {HappyReactive.SocketAcceptor, :start_link, [[], [name: HappyReactive.SocketAcceptor]]}
      },
      %{
        id: 1,
        start: {Flow, :start_link, [flow_to_handle()]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
