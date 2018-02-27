-- main.lua

--[[
main control loop:
- get temp sample
- update via MQTT
- (deep) sleep
]]

print("in main.lua")

--dofile("temperature.lua") 
--print("back from temperature.lua")

dofile("voltage.lua")
print("back from voltage.lua")

-- init mqtt client with keepalive timer slightly larger than sleep interval
m = mqtt.Client("clientid", (SLEEP_USEC/1000000) + KEEPALIVE_OVERHEAD_SEC)

-- init ds18b20
ds = require("ds18b20")

print("have MQTT client")

m:lwt("/lwt", LOCATION_ID.." is offline", 0, 0) -- setup Last Will and Testament (optional)
                                                -- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
                                                -- to topic "/lwt" if client don't send keepalive  packet

-- http://stackoverflow.com/questions/41523890/with-lua-nodemcu-how-can-i-wait-until-1-mqtt-publish-calls-have-been-made-befo
expectedPUBACK = 2 -- how many times does the PUBACK callback need to be called before we sleep?
                   -- FIXME: this is a nasty hack; need to wrap in something smarter that will
                   -- figure out the correct # on its own
function puback_cb() 
   PUBACK_cnt = (PUBACK_cnt or 0) + 1
   if PUBACK_cnt == expectedPUBACK then
--      print("night-night")
      rtctime.dsleep(SLEEP_USEC)
   end
end		

-- simple wrapper aroudn the mqqt lib's publish call - assumes qos is the same for all
-- NB: this enforce our convention re: concatenating device ID into the topic - so only the bare topic gets passed
function mqtt_pub(topic, payload)
   full_topic = topic.."/"..LOCATION_ID
   m:publish(full_topic,payload,1,0,puback_cb)
end

local function report_temp(temp)
   val = nil
   print("Found ", #ds.sens, " sensors")
   if (#ds.sens < 1)
   then
      -- error
      print("ERROR: didn't find any sensors")
      val = "ERROR: no temp sensors found"
   elseif (#ds.sens > 1)
   then
      print("WARNING: using first of %d sensors found", #ds.sens)
   end

   addr, val = next(temp, nil)  -- get first KVP from the table

   if (val ~= nil)
   then
      print("publishing temp val: ", val)
      mqtt_pub("temp",val)
   else
      print("unexpectedly got nil for val... debug details follow")
      print("temp:", tdump(temp))
      print("ds.sens:", tdump(ds.sens))
   end
end

function read_ds18b20()
   print("reading temp")
   ds:read_temp(report_temp, TEMP_PORT, ds.C)
end


function mainloop(client) 
   read_ds18b20()
   -- temp, humi = get_temp()
   -- if (temp ~= nil) then
   --    print(string.format("temp: %d", temp))
   --    print(string.format("humi: %d", humi))
   --    mqtt_pub("temp",temp)
   --    mqtt_pub("humi",humi)
   -- end
   voltage = get_voltage()
   if (voltage ~= nil) then
      print(string.format("voltage: %d", voltage))
      mqtt_pub("voltage",voltage)
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

do_mqtt_connect()
