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

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def has_key?(key) do
    GenServer.call(@name, {:has_key, key})
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

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

  def handl_call({:has_key, key}, _from, data) do
    case Map.has_key?(data, key) do
      true -> {:reply, :ok, data}
      _ -> {:reply, :error, data}
    end
  end

  def handle_cast({:delete, key}, data) do
    {:noreply, Map.delete(data, key)}
  end

  def handle_cast(:clear) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  

  # helper
end
