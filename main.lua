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

-- init mqtt client with keepalive timer 120sec
-- FIXME: does mqtt keepalive timer influence deep sleep time (or vice versa)?
m = mqtt.Client("clientid", 120, "8266test", "password")

print("have MQTT client")

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", "offline", 0, 0)  -- FIXME - should this be in connect()? 
--[[ more to the point, is it actually useful in a situation like this one?  
       (answer: yes, provided the timeout is longer than the sleep interval, 
        I think this will tell us when the client dies)
--]] 

-- http://stackoverflow.com/questions/41523890/with-lua-nodemcu-how-can-i-wait-until-1-mqtt-publish-calls-have-been-made-befo
expectedPUBACK = 3 -- how many times does the PUBACK callback need to be called before we sleep?
function puback_cb() 
	PUBACK_cnt = (PUBACK_cnt or 0) + 1
	if PUBACK_cnt == expectedPUBACK then
		rtctime.dsleep(SLEEP_USEC)
	end
end		

function mainloop(client) 
--	print("connected - at top of loop")
	m:publish("uptime".."/"..LOCATION_ID,tmr.time(),1,0, function(client) print("sent uptime") end) 

	temp, humi = get_temp()
	if (temp ~= nil) then 
		print(string.format("temp: %d", temp))
		print(string.format("humi: %d", humi))
		m:publish("temp".."/"..LOCATION_ID,temp,1,0)
		m:publish("humi".."/"..LOCATION_ID,humi,1,0, puback_cb)
	end
end

function handle_mqtt_error(client, reasno)
	print("Failed to connect to MQTT server, reason: "..reason)
	tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function do_mqtt_connect() -- FIXME: uses global client 'm' (yuck)
	m:connect(MQTT_SVR, 1883, 0, mainloop, handle_mqtt_error)
end	

m:on("connect", mainloop)  -- FIXME: is this redundant with the callback in the connect() call?
m:on("offline", function(client) is_connected = false print ("offline") end)

do_mqtt_connect()
