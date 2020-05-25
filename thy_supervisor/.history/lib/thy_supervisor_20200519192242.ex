defmodule ThySupervisor do
  use GenServer

  @spec start_link(Tuple) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(child_spec_list) do
    GenServer.start_link(__MODULE__, child_spec_list)
  end

  def start_child(supervisor, child_spec) do
    GenServer.call(supervisor, {:start_child, child_spec})
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

  def handle_call({:start_child, child_spec}, _from, state) do
    case start_child(child_spec) do
      {:ok, pid} ->
        new_state = state |> HashDict.put(pid, child_spec)
        {:reply, {:ok, pid}, new_state}

      :error ->
        {:reply, {:error, "error starting child"}, state}
    end
  end

  defp start_child([mod, fun, args]) do
    case apply(mod, fun, args) do
      pid when is_pid(pid) ->
        {:ok, pid}

      _ ->
        :error
    end
  end

  defp start_children([child_spec|rest]) do
    case start_child(child_spec)
  end
end
