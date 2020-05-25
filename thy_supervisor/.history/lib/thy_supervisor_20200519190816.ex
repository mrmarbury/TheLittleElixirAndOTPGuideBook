defmodule ThySupervisor do
  use GenServer

  def start_link(child_spec_list) do
    GenServer.start_link(__MODULE__, child_spec_list)
  end

  def init([child_spec_list]) do
    Process.flag(:trag_exit, true)
    state = child_spec_list |>
  end
end
