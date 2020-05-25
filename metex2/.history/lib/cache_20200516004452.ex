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
  end

  def delete(key)

  # Server

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, data) do
    new_data = Map.put(data, key, value)
    {:reply, "Key #{key} written", new_data}
  end

  def handle_call({:read, key}, _from, data) do
    case Map.has_key?(data, key) do
      true -> {:reply, Map.get(data, key), data}
      _ -> {:reply, :error, data}
    end
  end

  # helper
end
