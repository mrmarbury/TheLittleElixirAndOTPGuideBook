defmodule Metex do
  def temperature_of(cities) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])
    cities |> Enum.each(fn(city) ->
      worker_pid = spawn(Metex.Worker, :loop, [])
      
    end)
  end
end
