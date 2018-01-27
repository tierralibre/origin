defmodule UiWeb.EnvirophatView do
    use UiWeb, :view

    def read_sensors() do

        python_code = 
        """
        from envirophat import light, motion, weather, leds;
          lux = light.light(); 
          heading = motion.heading(); 
          temp = weather.temperature(); 
          press = weather.pressure(); 
          
          data = 'lux:', lux, 
                 'heading:',heading, 
                 'temp:', temp, 
                 'press:', press; 
                 
          print data;
        """
        {result, _} = System.cmd("python", ["-c", python_code])

        IO.inspect(result)
        |> to_string()
    end

    
end