-- mqqt_simpletest.lua

--[[

playground for testing MQQT details 

]]

--dofile("temp.lua")

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client("clientid", 120, "8266test", "password")

m:lwt("/lwt", "offline", 0, 0) 

function main(client) 
	print("connected - at top of main")

	m:publish("someval",12345,1,0, function(client)  
		rtctime.dsleep(SLEEP_USEC)		
	end)
end

m:on("connect", main)
m:on("offline", function(client) is_connected = false print ("offline") end)

m:connect(MQQT_SVR, 1883, 0, mainloop, 
                             function(client, reason) print("failed reason: "..reason) end)

