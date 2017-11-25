
-- --------- -- wifi
SSID = "wireless0n"
PASSWORD = "wifi password goes here"
MY_IP = "172.16.78.51"

-- --------- -- mqqt
MQTT_SVR = "mymqtt-srv.domain.com"
LOCATION_ID = "shop"

-- --------- -- DHT22 sensor
-- NB: DHT_PORT can't be 0
--  (hardware nb: port is connected to +3.3v w/ 10k resistor)

-- this is Huzzah 8266 board pin #2, which corresponds to NodeMCU pin 4
DHT_PORT = 4 

-- this is Sparkfun Thing 8266 board pin #4, which corresponds to NodeMCU pin 2
--DHT_PORT = 2

-- --------- -- operation
--SLEEP_USEC = 5000000 -- 5s
--SLEEP_USEC = 300000000 -- 5m
--SLEEP_USEC = 10000000 -- 10s
SLEEP_USEC = 600000000 -- 10m
