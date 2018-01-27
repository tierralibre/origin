defmodule UiWeb.EnvirophatController do
    use UiWeb, :controller
  
    def index(conn, _params) do
      render(conn, "index.html", result: "result")
    end
  end