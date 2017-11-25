#!/bin/bash

# very simplistic ESP8266 file uploader - works on files in CWD only, doesn't understand dirs,
#   doesn't remove files on the target that aren't in the local dir, etc.

# die on errors
set -e

# FTDI cable
export SERIALPORT=/dev/ttyUSB1
#export SERIALPORT=/dev/tty.usbserial-AK059AKS
#export SERIALPORT=/dev/tty.usbserial-FTDOPA5M

echo "********* Before upload, files are:" 
nodemcu-uploader file list
echo "***************************************"

for f in *.lua
do
	echo "uploading $f"
#	nodemcu-uploader upload $f --compile 
	nodemcu-uploader upload $f
done

echo "********* After upload, files are:" 
nodemcu-uploader file list
echo "***************************************"


