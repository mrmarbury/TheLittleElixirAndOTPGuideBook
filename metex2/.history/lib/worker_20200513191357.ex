defmodule Metex2.Worker do
  use GenServer

  ## Client API

  @spec start_link([
          {:debug, [:log | :statistics | :trace | {any, any}]}
          | {:hibernate_after, :infinity | non_neg_integer}
          | {:name, atom | {:global, any} | {:via, atom, any}}
          | {:spawn_opt,
             :link
             | :monitor
             | {:fullsweep_after, non_neg_integer}
             | {:min_bin_vheap_size, non_neg_integer}
             | {:min_heap_size, non_neg_integer}
             | {:priority, :high | :low | :normal}}
          | {:timeout, :infinity | non_neg_integer}
        ]) :: :ignore | {:error, any} | {:ok, pid}
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
        {:reply, :error, states}
    end
  end

  ## Helper Functions

  defp temperature_of(location) do
    location |> url_for |> HTTPoison.get() |> parse_response()
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp apikey do
    "850bfe7a61f4f5b935c10b21f70d2f1b"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp update_states(old_states, location) do
    case Map.has_key?(old_states, location) do
      true -> Map.update!(old_states, location, &(&1 + 1))
      false -> Map.put_new(old_states, location, 1)
    end
  end
end