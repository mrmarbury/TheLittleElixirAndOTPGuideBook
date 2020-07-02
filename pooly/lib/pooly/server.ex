defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct supervisor: nil,
              worker_supervisor: nil,
              size: nil,
              workers: nil,
              mfa: nil,
              monitors: nil
  end

  def start_link(supervisor, pool_config) do
    GenServer.start_link(__MODULE__, [supervisor, pool_config], name: __MODULE__)
  end

  def checkout do
    GenServer.call(__MODULE__, :checkout)
  end

  def checkin(worker_pid) do
    GenServer.cast(__MODULE__, {:checkin, worker_pid})
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  ##### CALLBACKS #####

  def init([supervisor, pool_config]) when is_pid(supervisor) do
    monitors = :ets.new(:monitors, [:private])
    init(pool_config, %State{supervisor: supervisor, monitors: monitors})
  end

  def init([{:mfa, mfa} | rest], state) do
    init(rest, %{state | mfa: mfa})
  end

  def init([{:size, size} | rest], state) do
    init(rest, %{state | size: size})
  end

  def init([_ | rest], state) do
    init(rest, state)
  end

  def init([], state) do
    send(self(), :start_worker_supervisor)
    {:ok, state}
  end

  def handle_call(:checkout, {from_pid, _ref}, %{workers: workers, monitors: monitors} = state) do
    case workers do
      [worker | rest] ->
        ref = Process.monitor(from_pid)
        true = :ets.insert(monitors, {worker, ref})
        {:reply, worker, %{state | workers: rest}}

      [] ->
        {:reply, :noproc, state}
    end
  end

  def handle_call(:status, _from, %{workers: workers, monitors: monitors} = state) do
    {:reply, {length(workers), :ets.info(monitors, :size)}, state}
  end

  def handle_cast({:checkin, worker}, %{workers: workers, monitors: monitors} = state) do
    case :ets.lookup(monitors, worker) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(monitors, pid)
        {:noreply, %{state | workers: [pid | workers]}}

      [] ->
        {:noreply, state}
    end
  end

  def handle_info(
        :start_worker_supervisor,
        state = %{supervisor: supervisor, mfa: mfa, size: size}
      ) do
    {:ok, worker_supervisor} = Supervisor.start_child(supervisor, supervisor_spec(mfa))
    workers = prepopulate(size, worker_supervisor)
    {:noreply, %{state | worker_supervisor: worker_supervisor, workers: workers}}
  end

  ##### PRIVATE #####

  defp supervisor_spec(mfa) do
    opts = [restart: :temporary]
    supervisor(Pooly.WorkerSupervisor, [mfa], opts)
  end

  defp prepopulate(size, supervisor) do
    prepopulate(size, supervisor, [])
  end

  defp prepopulate(size, _supervisor, workers) when size < 1 do
    workers
  end

  defp prepopulate(size, supervisor, workers) do
    prepopulate(size - 1, supervisor, [new_worker(supervisor) | workers])
  end

  defp new_worker(supervisor) do
    {:ok, worker} = Supervisor.start_child(supervisor, [[]])
    worker
  end
end
