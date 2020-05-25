defmodule ThyWorker do
  def start_link do
    spawn(fn -> loop end)
  end

  def loop do
    receive do
      :stop -> :ok
      msg ->
        IO.inspect(device, item, opts)
        # code
    end

  end
end
