defmodule Metex2.Cache do
  use GenServer

  # Client

  def start(opts \\ []) do
    GenServer.start(module, init_arg, options \\ [])
  end

  # Server

  # helper

end
