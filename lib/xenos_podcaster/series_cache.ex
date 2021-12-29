defmodule XenosPodcaster.SeriesCache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:ets_table_name, :series_table},
        {:log_limit, 1_000_000}
      ],
      opts
    )
  end

  def fetch(series, default_function) do
    case get(series) do
      {:not_found} -> set(series, default_function.())
      {:found, result} -> result
    end
  end

  defp get(series) do
    case GenServer.call(__MODULE__, {:get, series}) do
      [] -> {:not_found}
      [{_series, result}] -> {:found, result}
    end
  end

  defp set(series, value) do
    GenServer.call(__MODULE__, {:set, series, value})
  end

  # GenServer call backs

  def handle_call({:get, series}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, series)
    {:reply, result, state}
  end

  def handle_call({:set, series, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {series, value})
    {:reply, value, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args
    :ets.new(ets_table_name, [:named_table, :set, :private])
    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end
end
