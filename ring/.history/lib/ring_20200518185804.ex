defmodule Ring do
  def create_processes(number) do
    1..number |> Enum.map(fn _ -> spawn(fn -> loop end) end)
  end

  def loop do
    receive do
      {:message_type, value} ->
        # code
    end

  end
end
