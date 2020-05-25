defmodule Ring do
  def create_processes(number) do
    1..number |> Enum.map(fn _ -> spawn(fn -> loop end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()

      :crash ->
        1 / 0
    end
  end

  def link_processes(procs) do
    link_
  end
end
