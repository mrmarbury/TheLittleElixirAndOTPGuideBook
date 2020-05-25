defmodule Metex2.Cache do
  use GenServer

  @name Cache

  # Client

  def start(options \\ []) do
    GenServer.start(__MODULE__, :ok, options ++ [name: Cache])
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  # Server

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, data) do
    Map.put(data, key, value)
  end

  # helper
end
