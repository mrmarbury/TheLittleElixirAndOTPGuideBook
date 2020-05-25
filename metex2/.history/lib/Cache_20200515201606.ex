defmodule Metex2.Cache do
  use GenServer

  @name CacheW

  # Client

  def start(options \\ []) do
    GenServer.start(__MODULE__, :ok, options ++ [name: ])
  end

  # Server

  # helper

end
