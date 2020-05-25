defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start(___MODULE__, init_arg, options \\ [])
  end
end
