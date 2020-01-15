#! /bin/bash

nmcli connection down $1
nmcli connection delete $1
rm /etc/NetworkManager/system-connections/$1.nmconnection
rm /etc/NetworkManager/dispatcher.d/02_startOpenVpnOnConnectionUp
