defmodule Metex2.Cache do
  use GenServer

  # Client

  def start(options \\ []) do
    GenServer.start(__MODULE__, :ok, options )
  end

  # Server

  # helper

end
