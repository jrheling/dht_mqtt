dht_mqtt

Lua/nodeMCU based temp sensor that updates via MQTT
- uses DS18B20 (one-wire) sensor
- expects nodemcu firmware with the following modules:
	adc dht file gpio http mdns mqtt net 
	node ow pwm rtctime sntp tmr uart wifi
 

Note: also needs ds18b20.lua from https://github.com/nodemcu/nodemcu-firmware/tree/master/lua_modules/ds18b20 
