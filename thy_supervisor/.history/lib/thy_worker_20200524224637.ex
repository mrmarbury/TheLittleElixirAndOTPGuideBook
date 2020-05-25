defmodule ThyWorker do
  def start_link do
    spawn(fn -> loop end)
  end

  def loop do
    receive do
      {:message_type, value} ->
        # code
    end

  end
end
