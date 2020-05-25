defmodule Metex.worker do
  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse
  end
end
