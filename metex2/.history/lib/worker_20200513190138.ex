defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  ## Server Callback

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, states) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_states = update_states(states, location)
        {:reply, "#{temp}C", new_states}

      _ ->
        {:reply, :error, stats}
    end
  end

  ## Helper Functions
end
