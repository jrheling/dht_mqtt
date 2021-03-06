
-- --------- -- wifi
-- FIXME: better to use the nodemcu built-in wifi cred mgmt stuff
WIFI_CONFIG = {}
WIFI_CONFIG.ssid = "willowbend"
WIFI_CONFIG.pwd = "now is the ti"

MY_IP = "172.16.78.53"

-- --------- -- mqqt
MQTT_SVR = "allyourbase.netfluvia.org"
LOCATION_ID = "test-num1"

-- --------- -- DHT22 sensor
-- NB: DHT_PORT cannot be 0
--  (hardware nb: port is connected to +3.3v w/ 10k resistor)

-- this is Huzzah 8266 board pin #2, which corresponds to NodeMCU pin 4
TEMP_PORT = 4

-- this is Sparkfun Thing 8266 board pin #4, which corresponds to NodeMCU pin 2
--TEMP_PORT = 2

-- maintenance mode button (when held down, we skip init)
MAINT_PORT = 1 -- Huzzah board pin #5

-- analog I/O port (used for reading voltage)
VOLTAGE_PORT = 0

-- --------- -- operation
WATCHDOG_INTERVAL = 20 -- seconds
KEEPALIVE_OVERHEAD_SEC = 30

--SLEEP_USEC = 5000000 -- 5s
--SLEEP_USEC = 300000000 -- 5m
--SLEEP_USEC = 10000000 -- 10s
SLEEP_USEC = 600000000 -- 10m

