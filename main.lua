-- main.lua

--[[
main control loop:
- get temp sample
- update via MQTT
- (deep) sleep
]]

print("in main.lua")

dofile("temperature.lua") 
print("back from temperature.lua")

dofile("voltage.lua")
print("back from voltage.lua")

-- init mqtt client with keepalive timer slightly larger than sleep interval
-- FIXME: cheaper division w/ bitshift - could add 'bit' module (runtime vs. image overhead tradeoff)
m = mqtt.Client("clientid", (SLEEP_USEC/1000000) + KEEPALIVE_OVERHEAD_SEC)

print("have MQTT client")

m:lwt("/lwt", LOCATION_ID.." is offline", 0, 0) -- setup Last Will and Testament (optional)
                                                -- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
                                                -- to topic "/lwt" if client don't send keepalive  packet

-- http://stackoverflow.com/questions/41523890/with-lua-nodemcu-how-can-i-wait-until-1-mqtt-publish-calls-have-been-made-befo
expectedPUBACK = 4 -- how many times does the PUBACK callback need to be called before we sleep?
                   -- FIXME: this is a nasty hack; need to wrap in something smarter that will
                   -- figure out the correct # on its own
function puback_cb() 
   PUBACK_cnt = (PUBACK_cnt or 0) + 1
   if PUBACK_cnt == expectedPUBACK then
      rtctime.dsleep(SLEEP_USEC)
   end
end		

function mainloop(client) 
   m:publish("uptime".."/"..LOCATION_ID,tmr.time(),1,0, function(client) print("sent uptime") end) 

   temp, humi = get_temp()
   if (temp ~= nil) then
      print(string.format("temp: %d", temp))
      print(string.format("humi: %d", humi))
      m:publish("temp".."/"..LOCATION_ID,temp,1,0)
      m:publish("humi".."/"..LOCATION_ID,humi,1,0, puback_cb)
   end
   voltage = get_voltage()
   if (voltage ~= nil) then
      print(string.format("voltage: %d", voltage))
      m:publish("voltage".."/"..LOCATION_ID,voltage,1,0, puback_cb)
   end
end

function handle_mqtt_error(client, reason)
   print("Failed to connect to MQTT server, reason: "..reason)
   tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function handle_connection()
   mainloop()
end

function do_mqtt_connect() -- FIXME: uses global client 'm' (yuck)
   m:connect(MQTT_SVR, 1883, 0, handle_connection, handle_mqtt_error)
end	

-- m:on("connect", mainloop)  -- FIXME: is this redundant with the callback in the connect() call?
-- this seems like pointless cruft
--m:on("offline", function(client) is_connected = false print ("offline") end)

do_mqtt_connect()
