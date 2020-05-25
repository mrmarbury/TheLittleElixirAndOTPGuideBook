defmodule Metex.Coordinator do
  def loop(results \\ [], results_expected) do
    receive do
      {:ok, results} -> new_results = [result|results]
      
    end
  end
end
