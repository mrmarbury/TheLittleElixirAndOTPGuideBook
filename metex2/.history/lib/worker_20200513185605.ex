defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, lecation) do
    GenServer.call(pid, {:location, location}, request, timeout \\ 5000)
  end
  ## Server Callback

  def init(:ok) do
    {:ok, %{}}
  end

  ## Helper Functions
end
