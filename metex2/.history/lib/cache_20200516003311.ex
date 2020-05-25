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

  def read(key) do
    GenServer.call(@name, {:read, key})
  end  # Server

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, data) do
    Map.put(data, key, value)
    {:reply, "Key #{key} written", data}
  end

  def handle_call({:read, key}, _from, data) do
    case Map.has_key?(data, key), key}, _from, data)
  end

  # helper
end
