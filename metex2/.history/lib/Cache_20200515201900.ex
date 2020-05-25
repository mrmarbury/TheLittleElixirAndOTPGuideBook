defmodule Metex2.Cache do
  use GenServer

  @name Cache

  # Client

  def start(options \\ []) do
    GenServer.start(__MODULE__, :ok, options ++ [name: Cache])
  end

  def write(@name, :writekey, value)

  # Server

  def init(:ok) do
    {:ok, %{}}
  end

  # helper
end
