defmodule Metex.Worker do
  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response
  end

  defp url_for(location)
end
