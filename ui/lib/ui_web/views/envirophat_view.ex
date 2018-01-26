defmodule UiWeb.EnvirophatView do
    use UiWeb, :view

    def read_sensors(count) do
        Ui.Earth.EnvirophatSense.call_read_sensors(count)
        |> to_string()
    end
end