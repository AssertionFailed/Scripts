#!/bin/bash

status=`expressvpn status | head -n 1 | awk '{print $1}' | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'`

if [[ "$status" == "Connected" ]]
then
	echo -n "* Disconnect from current server ... "
	expressvpn disconnect > /dev/null
	echo "OK"
fi

while true
do
	server=`expressvpn list all | awk '{ print $1}' | tail -n +5 | head -n -2 | shuf -n 1`
	echo -n "* Connecting to $server ... "
	expressvpn connect $server > /dev/null
	echo "OK"
	sleep 1800 # 15min
	echo -n "* Disconnecting from $server ... "
	expressvpn disconnect > /dev/null
	echo "OK"
done
