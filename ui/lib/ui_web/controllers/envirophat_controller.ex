defmodule UiWeb.EnvirophatController do
    use UiWeb, :controller
  
    def index(conn, _params) do
      cache = Era.Cache.server_process("envirophat")
      results = Era.Server.all_entries(cache)
      #results = [%{uno: "uno"}, %{dos: "dos"}]
      IO.inspect(results)
      render(conn, "index.html", results: results)
    end
  end