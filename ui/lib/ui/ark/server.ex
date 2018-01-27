defmodule Ark.Server do
    use GenServer, restart: :temporary
  
    def start_link(name) do
      GenServer.start_link(Ark.Server, name, name: via_tuple(name))
    end
  
    def add_entry(ark_server, new_entry) do
      GenServer.cast(ark_server, {:add_entry, new_entry})
    end
  
    def entries(ark_server, date) do
      GenServer.call(ark_server, {:entries, date})
    end
  
    defp via_tuple(name) do
      Ark.ProcessRegistry.via_tuple({__MODULE__, name})
    end
  
    @impl GenServer
    def init(name) do
      IO.puts("Starting Ark server for #{name}")
      {:ok, {name, Ark.Database.get(name) || Ark.List.new()}}
    end
  
    @impl GenServer
    def handle_cast({:add_entry, new_entry}, {name, ark_list}) do
      new_state = Ark.List.add_entry(ark_list, new_entry)
      Ark.Database.store(name, new_state)
      {:noreply, {name, new_state}}
    end
  
    @impl GenServer
    def handle_call({:entries, date}, _, {name, ark_list}) do
      {
        :reply,
        Todo.List.entries(ark_list, date),
        {name, ark_list}
      }
    end
  end