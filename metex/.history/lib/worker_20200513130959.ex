defmodule Metex.Worker do
  def temperature_of(location) do
    result = location |> url_for |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} -> "#{location}: #{temp}C"
      {:error, reason} -> "Error on #{location}. Message was #{reason}"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp apikey do
    "850bfe7a61f4f5b935c10b21f70d2f1b"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Jason.decode!() |> compute_temperature
  end

  defp parse_response({:error, %HTTPoisen.(r)}) do
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
end
