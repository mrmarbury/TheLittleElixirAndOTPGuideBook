defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  ## Server Callback

  def init(:ok) do
    {:ok, }
  end
end
