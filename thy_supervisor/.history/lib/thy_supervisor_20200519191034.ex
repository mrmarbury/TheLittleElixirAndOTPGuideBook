defmodule ThySupervisor do
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(child_spec_list) do
    GenServer.start_link(__MODULE__, child_spec_list)
  end

  @spec init(any) :: {:ok, any}
  def init([child_spec_list]) do
    Process.flag(:trag_exit, true)

    state =
      child_spec_list
      |> start_children()
      |> Enum.into(HashDict.new())

    {:ok, state}
  end
end
