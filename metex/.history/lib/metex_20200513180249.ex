defmodule Metex do
  def temperature_of(cities) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, )
  end
end
