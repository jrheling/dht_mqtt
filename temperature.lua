-- sense temp using DS18B20

--pin = DHT_PORT

-- returns nil on error, else temp in C
	-- returns values 1000x actual (3 decimal digits expressed as int)
--   e.g. 23.15 degrees is 23150

-- Note: assumes only one device on the 1Wire bus. (FIXME)

///// START HERE - this feels un-luaish. Need to figure out how to deal w/ asynchronity in the context of the function call

   ****************************************************************
   I'm fighting too hard against the way lua wants to do this. Stop. Don't. Go with the flow - main() needs rearchitecture to work with callbacks rather than a synchronous get_temp()
   
function get_temp()


   
   status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PORT)
   if status == dht.OK then
      -- Integer firmware using this example
      t = (temp * 1000) + temp_dec
      h = (humi * 1000) + humi_dec

      -- print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
      --       math.floor(temp),
      --       temp_dec,
      --       math.floor(humi),
      --       humi_dec
      -- ))
      return t,h

   elseif status == dht.ERROR_CHECKSUM then
      print( "DHT Checksum error." )
      return nil
   elseif status == dht.ERROR_TIMEOUT then
      print( "DHT timed out." )
      return nil
   end
end
