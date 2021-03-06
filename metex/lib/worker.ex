defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} -> send(sender_pid, {:ok, temperature_of(location)})
      _ -> IO.puts("Don't know how to process this message")
    end

    loop()
  end

  def temperature_of(location) do
    result = location |> url_for |> HTTPoison.get() |> parse_response

    case result do
      {:ok, temp} -> "#{location}: #{temp}C"
      {:error, reason} -> "Error for location: #{location}. Message was: #{reason["message"]}"
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

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 404}}) do
    {:error, body |> Jason.decode!()}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason |> Jason.decode!()}
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
