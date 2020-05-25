defmodule ThyWorker do
  def start_link do
    spawn(fn -> loop end)
  end

  def loop do
    
  end
end
