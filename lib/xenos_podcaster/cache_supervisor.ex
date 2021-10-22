defmodule XenosPodcaster.CacheSupervisor do
  use Supervisor

  def start_link(_opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {XenosPodcaster.SeriesCache, [name: XenosPodcaster.SeriesCache]}
      #      worker(, [[name: XenosPodcaster.SeriesCache]])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
