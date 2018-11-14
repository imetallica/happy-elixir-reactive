defmodule HappyReactive.Producer do
  @moduledoc """
  From 0.14, GenStage automatically buffers stuff.
  """
  use GenStage
  require Logger

  def start_link(args) do
    GenStage.start_link(__MODULE__, args)
  end

  def init(args) do
    Logger.debug("#{inspect(self())}: Args is #{inspect(args)}")
    {:producer_consumer, %{}, [args]}
  end

  def handle_demand(_demand, state) do
    Logger.debug("Hi from #{__MODULE__}: handle demand.")
    {:noreply, [], state}
  end

  def handle_events(events, _from, state) do
    Logger.debug("Hi from #{__MODULE__}: handle events #{inspect(events)}")
    {:noreply, events, state}
  end
end
