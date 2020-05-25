defmodule ThySupervisor do
  use GenServer

  @spec start_link(Tuple) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(child_spec_list) do
    GenServer.start_link(__MODULE__, child_spec_list)
  end

  @spec init(Tuple) :: {:ok, HashDict}
  def init([child_spec_list]) do
    Process.flag(:trag_exit, true)

    state =
      child_spec_list
      |> start_children()
      |> Enum.into(HashDict.new())

    {:ok, state}
  end

  def handle_call()
end
