-- sense temp using DHT22

-- based on http://nodemcu.readthedocs.io/en/master/en/modules/dht/

--pin = DHT_PORT

-- returns nil on error, else tmp,hum tuple
	-- returns values 1000x actual (3 decimal digits expressed as int)
	--   e.g. 23.15 degrees is 23150
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
