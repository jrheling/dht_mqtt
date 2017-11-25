
-- make sure we've got the ADC in the correct mode for reading voltage
if adc.force_init_mode(adc.INIT_VDD33)
then
   print("changing ADC mode to INIT_VDD33 and restarting")
   node.restart()
   return
end

-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
-- FIXME: better to use nodemcu's built-in wifi cred mgmt stuff
dofile("config.lua")

-- reg wifi callback
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
			  print("connected to WiFi SSID: "..T.SSID)
			  print("Running main.lua in 3 seconds...")  -- FIXME: remove this after more testing
			  tmr.alarm(0, 3000, 0, function() dofile("main.lua") end)
end)

-- connect
print("Configuring WiFi... ")
wifi.setmode(wifi.STATION)
wifi.sta.setip({ip=MY_IP,netmask="255.255.255.0",gateway="172.16.78.1"}) -- FIXME: move to config.lua
net.dns.setdnsserver("172.16.78.1")
wifi.sta.config(WIFI_CONFIG) -- NB: defaults to auto-connect; no need to call wifi.sta.connect() explicitly
print("configured")


