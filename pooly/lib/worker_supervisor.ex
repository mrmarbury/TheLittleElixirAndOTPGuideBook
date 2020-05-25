defmodule Pooly.WorkerSupervisor do
  use Supervisor

  ###########
  ### API ###
  ###########

  def start_link({_, _, _} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  #################
  ### Callbacks ###
  #################

  def init({m,f,a}) do
    
  end
end
