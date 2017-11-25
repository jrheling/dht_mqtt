-- connect to MQQT server and periodically ping it

-- basic example; based on http://nodemcu.readthedocs.io/en/master/en/modules/mqtt/

print "DEBUG: in mqqt_pulse.lua"

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client("clientid", 120, "8266test", "password")

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
is_connected = false
m:connect(MQQT_SVR, 1883, 0, function(client) is_connected = true print("connected") end, 
                                     function(client, reason) print("failed reason: "..reason) end)

-- Calling subscribe/publish only makes sense once the connection
-- was successfully established. In a real-world application you want
-- move those into the 'connect' callback or make otherwise sure the 
-- connection was established.

-- nasty hack for early test
tmr.alarm(0, 2000, tmr.ALARM_AUTO, function()
		if (is_connected == true) then
			print "DEBUG going to try to publish"
			-- subscribe topic with qos = 0
			m:subscribe("/topic",0, function(client) print("subscribe success") end)
			-- publish a message with data = hello, QoS = 0, retain = 0
			m:publish("/topic","hello",0,0, function(client) print("sent") end)

			-- m:close();
			-- you can call m:connect again
		else
			print "DEBUG not connected"
		end
	end)