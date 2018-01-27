defmodule UiWeb.EnvirophatView do
    use UiWeb, :view

    def read_sensors(count) do
        Ui.Earth.EnvirophatSense.call_read_sensors(count)
        |> to_string()
    end

    def read_sensors() do
        {result, _} = System.cmd("python", ["-c", "from envirophat import light, motion, weather, leds;lux = light.light(); heading = motion.heading(); temp = weather.temperature(); press = weather.pressure(); data = 'lux:', lux, 'heading:',heading, 'temp:', temp, 'press:', press; print data;"])

        IO.inspect(result)
        |> to_string()
    end

    
end