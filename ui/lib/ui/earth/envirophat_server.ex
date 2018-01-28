defmodule Ui.Earth.EnvirophatServer do
  @name :envirophat_server
  @refresh_interval :timer.seconds(10)

  use GenServer

  defmodule State do
    defstruct cache_size: 0, entries: [], cache: nil
  end

  # Client Interface

  def start_link() do
    IO.puts("Starting the envirophat server...")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def get_entries() do
    GenServer.call(@name, :get_entries)
  end

  def get_sensor_data() do
    GenServer.call(@name, :get_sensor_data)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server Callbacks

  def init(state) do
    # entries = fetch_recent_pledges_from_service()
    go = fetch_envirophat_data(state)
    IO.puts("go: #{inspect(go)}")
    entries = []
    cache = Era.Cache.server_process("envirophat")
    new_state = %{state | entries: entries, cache: cache}
    schedule_refresh()
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | entries: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{state | cache_size: size}
    {:noreply, new_state}
  end

  def handle_call(:get_entries, _from, state) do
    {:reply, state.entries, state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    result = fetch_envirophat_data(state)
    {:reply, result, state}
  end

  def handle_call({:entries_for_date, date}, _from, state) do
    {:reply, state.entries, state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing the cache")
    result = fetch_envirophat_data(state)
    schedule_refresh()
    {:noreply, state}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp fetch_envirophat_data(state) do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    python_code = """
    from envirophat import light, motion, weather, leds;lux = light.light(); heading = motion.heading(); temp = weather.temperature(); press = weather.pressure(); data = 'lux:', lux, 'heading:',heading, 'temp:', temp, 'press:', press; print data;
    """

    {result, _} = System.cmd("python", ["-c", python_code])

    raw =
      IO.inspect(result)
      |> to_string()

    # Example return value:
    Era.Server.add_entry(state.cache, %{
      date: Date.utc_today(),
      raw: raw,
      date_time: DateTime.utc_now()
    }) |> IO.inspect()

    [{"raw", raw}]
  end
end