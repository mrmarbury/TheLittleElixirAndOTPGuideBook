defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  supervisor: nil, worker_supervisor: nil, size: nil: workers: nil, mfa: nil

  defmodule State do
    defstruct supervisor: nil, size: nil, mfa: nil
  end

  def start_link(supervisor, pool_config) do
    GenServer.start_link(__MODULE__, [supervisor, pool_config], name: __MODULE__)
  end


  ##### CALLBACKS #####

  def init([supervisor, pool_config]) when is_pid(supervisor) do
    init(pool_config, %State(supervisor: supervisor))
  end

  def init([{:mfa, mfa}| rest], state) do
    init(rest, %{state| mfa: mfa})
  end

  def init([{:size, size}|rest], state) do
    init(rest, %{state|size: size})
  end

  def init([_|rest], state) do
    init(rest, state)
  end

  def init([], state) do
    send(self, :start_worker_supervisor)
    {:ok, state}
  end

  def handle_info(:start_worker_supervisor, state = {:mfa, mfa, :supervisor, supervisor, :size, size}) do
    {:ok, worker_supervisor} = Supervisor.start_child(supervisor, supervisor_spec(mfa))
    workers = prepopulate(size, worker_supervisor)
    {:noreply, %{state | worker_supervisor: worker_supervisor, workers: workers}}
  end

  ##### PRIVATE #####

  defp supervisor_spec(mfa) do
    opts = {restart: :temporary}
    supervisor(Pooly.WorkerSupervisor, [mfa], opts)
  end

end
