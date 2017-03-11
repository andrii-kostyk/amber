#!/bin/sh
cd /home/pi/amber
thin start --ssl -a 192.168.0.200
chromium-browser 'https://192.168.0.200:3000'