defmodule Ring do
  def create_processes(number) do
    1..n |>Enum.map(fn _ -> spawn(fn -> loop end))
  end
end
