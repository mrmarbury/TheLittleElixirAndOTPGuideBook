defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  ## Server Callback

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _)
  ## Helper Functions
end
