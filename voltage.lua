-- sense battery voltage, using esp8266' built-in ADC

-- see https://nodemcu.readthedocs.io/en/master/en/modules/adc/



-- returns 1000x voltage
	--   e.g. 3480 means 3.48v
function get_voltage()
   v = adc.readvdd33()

   -- FIXME: some error/reasonable bounds checking
   return v
end
