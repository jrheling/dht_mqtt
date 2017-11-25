--[[

simple wrapper around real_init.lua, which is where the real work happens

the purpose of this file is to make it easy to blow it away from a device (e.g. with 'nodemcu-uploader file remove init.lua')
and still interactively run the code (via 'dofile("real_init.lua") from a serial console)

]]
dofile("real_init.lua")
