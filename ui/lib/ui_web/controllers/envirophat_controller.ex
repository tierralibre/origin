defmodule UiWeb.EnvirophatController do
    use UiWeb, :controller
  
    def index(conn, _params) do
      result = Ui.Earth.EnvirophatSense.call_read_sensors(3) |> to_string()
      render(conn, "index.html", result: result)
    end
  end