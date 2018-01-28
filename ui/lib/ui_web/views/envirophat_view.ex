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

        python_code =
        """
        from envirophat import light, motion, weather, leds;lux = light.light(); heading = motion.heading(); temp = weather.temperature(); press = weather.pressure(); data = 'lux:', lux, 'heading:',heading, 'temp:', temp, 'press:', press; print data;
        """

        {result, _} = System.cmd("python", ["-c", python_code])

        IO.inspect(result)
        |> to_string()
    end

   def envirophat_raw_data({id_1, raw_1},{id_2, raw_2}) do
    "Raw_1: #{inspect(raw_1)} Raw_2: #{inspect(raw_2)}"
   end

   def envirophat_raw_data(other) do
    IO.puts "raw_entry:< #{inspect(other)} >"
    "other"
   end


    
end