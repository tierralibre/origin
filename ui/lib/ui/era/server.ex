defmodule Era.Server do
    use GenServer, restart: :temporary
  
    def start_link(name) do
      GenServer.start_link(Era.Server, name, name: via_tuple(name))
    end
  
    def add_entry(era_server, new_entry) do
      GenServer.cast(era_server, {:add_entry, new_entry})
    end
  
    def all_entries(era_server) do
      GenServer.call(era_server, :all_entries)
    end

    def entries(era_server, date) do
      GenServer.call(era_server, {:entries, date})
    end
  
    defp via_tuple(name) do
      Era.ProcessRegistry.via_tuple({__MODULE__, name})
    end
  
    @impl GenServer
    def init(name) do
      IO.puts("Starting Era server for #{name}")
      {:ok, {name, Era.Database.get(name) || Era.List.new()}}
    end
  
    @impl GenServer
    def handle_cast({:add_entry, new_entry}, {name, era_list}) do
      new_state = Era.List.add_entry(era_list, new_entry)
      Era.Database.store(name, new_state)
      {:noreply, {name, new_state}}
    end
  
    @impl GenServer
    def handle_call({:entries, date}, _, {name, era_list}) do
      {
        :reply,
        Era.List.entries(era_list, date),
        {name, era_list}
      }
    end

    @impl GenServer
    def handle_call(:all_entries, _, {name, era_list}) do
      {
        :reply,
        Era.List.entries(era_list),
        {name, era_list}
      }
    end
  end