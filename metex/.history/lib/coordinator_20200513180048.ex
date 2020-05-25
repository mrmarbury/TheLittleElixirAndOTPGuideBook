defmodule Metex.Coordinator do
  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [result | results]

        if results_expected == Enum.count(new_results) do
          send(self(), :exit)
        end

        loop(new_results, Enum.count(results_expected))
      :exit ->
        IO.puts(results )
    end
  end
end