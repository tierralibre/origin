#lib/elixir_python_qrcode.ex
defmodule Ui.Qrcodes.Qrcode do
    @moduledoc """
    Documentation for ElixirPythonQrcode.
    """
    alias Ui.Qrcodes.Helper
  
    def encode(data, file_path) do
      call_python(:qrcode, :encode, [data, file_path])
    end
  
    def decode(file_path) do
      call_python(:qrcode, :decode, [file_path])
    end
    defp default_instance() do
      #Load all modules in our priv/python directory
      path = [:code.priv_dir(:ui), "python"] 
            |> Path.join()
      Helper.python_instance(to_charlist(path))
    end
  
    # wrapper function to call python functions using
    # default python instance
    defp call_python(module, function, args \\ []) do
      default_instance()
      |> Helper.call_python(module, function, args)
    end
  end