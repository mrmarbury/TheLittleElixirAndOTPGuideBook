defmodule Metex.Coordinator do
  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        if results
    end
  end
end