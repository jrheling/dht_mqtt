
-- make sure we've got the ADC in the correct mode for reading voltage
if adc.force_init_mode(adc.INIT_ADC)
then -- this only happens once per board (barring external changes)
   print("changing ADC mode to INIT_ADC and restarting")
   node.restart()
   return
end

-- set up software watchdog - this is our catch-all recovery method
--   (forced reboot after WATCHDOG_INTERVAL seconds)
tmr.softwd(WATCHDOG_INTERVAL)

-- reg wifi callback
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
			  print("connected to WiFi SSID: "..T.SSID)			  
			  dofile("main.lua")
--[[
			  print("Running main.lua in 3 seconds...")  -- FIXME: remove this after more testing
			  tmr.create():alarm(3000, tmr.ALARM_SINGLE, function() dofile("main.lua") end)
]]
end)

-- connect
print("Configuring WiFi... ")
wifi.setmode(wifi.STATION)
wifi.sta.setip({ip=MY_IP,netmask="255.255.255.0",gateway="172.16.78.1"}) -- FIXME: move to config.lua
net.dns.setdnsserver("172.16.78.1")
wifi.sta.config(WIFI_CONFIG) -- NB: defaults to auto-connect; no need to call wifi.sta.connect() explicitly
print("configured")


