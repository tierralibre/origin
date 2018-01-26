#lib/python_server.ex
defmodule Ui.Earth.EnvirophatSense do 
    use GenServer
    alias Ui.Python
    def start_link() do 
       GenServer.start_link(__MODULE__, [])
    end
    def init(args) do
       #start the python session and keep pid in state
       python_session = Python.start()
       #register this process as the message handler
       Python.call(python_session, :envirophat, :register_handler, [self()])
       {:ok, python_session}
    end
    def cast_count(count) do 
       {:ok, pid} = start_link()
       GenServer.cast(pid, {:count, count})
    end
 
    def call_count(count) do
       {:ok, pid} = start_link()
       # :infinity timeout only for demo purposes
       GenServer.call(pid, {:count, count}, :infinity)
    end

    def call_read_sensors(count) do
        {:ok, pid} = start_link()
        # :infinity timeout only for demo purposes
        GenServer.call(pid, {:read_sensors, count}, :infinity)
    end

    def cast_read_sensors(count) do 
        {:ok, pid} = start_link()
        GenServer.cast(pid, {:read_sensors, count})
    end

    # Server
 
    def handle_call({:count, count}, from, session) do 
       result = Python.call(session, :envirophat, :long_counter, [count])
       {:reply, result, session}
    end
    def handle_cast({:count, count}, session) do 
      Python.cast(session, count)
      {:noreply, session}
    end

    def handle_call({:read_sensors, count}, from, session) do 
        result = Python.call(session, :envirophat, :read_sensors, [count])
        {:reply, result, session}
    end
    def handle_cast({:read_sensors, count}, session) do 
        Python.cast(session, count)
        {:noreply, session}
    end

    def handle_info({:python, message}, session) do         
       IO.puts("Received message from python: #{inspect message}")
 
       #stop elixir process
       {:stop, :normal,  session}
    end
    def terminate(_reason, session) do 
      Python.stop(session)
      :ok
    end
 end