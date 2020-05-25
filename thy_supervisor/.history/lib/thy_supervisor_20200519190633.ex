defmodule ThySupervisor do
  use GenServer

  def start_link(child_spec_list) do
    GenServer.start_link(module, init_arg, options \\ [])
  end
end
