defmodule UiWeb.SystemController do
  use UiWeb, :controller

  def index(conn, _params) do
    result = Nerves.Runtime.poweroff()
    IO.inspect(result)
    render(conn, "index.html")
  end
end