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
    case Map.has_key?()
  end
end
