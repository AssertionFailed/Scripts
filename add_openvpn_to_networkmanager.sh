#!/bin/bash

openVpnFileName=`basename "$1" | cut -d. -f1`

import_vpn_connection() {
	nmcli connection import type openvpn file $1
	echo "* Open vpn file imported"
}

create_dispatcher_file() {
	scriptName=02_startOpenVpnOnConnectionUp

	echo "
#!/bin/bash
if [ \"\$2\" = \"up\" ]; then
	status=`expressvpn status | head -n 1 | awk '{print $1}' | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'`
        if [[ \"$status\" == \"Disconnected\" ]]; then
		nmcli connection up $1
	fi
fi" > /etc/NetworkManager/dispatcher.d/$scriptName

	chmod +x /etc/NetworkManager/dispatcher.d/$scriptName

	echo "* File added to network manager dispatcher"
}

add_vpn_credentials() {
	file=/etc/NetworkManager/system-connections/$1.nmconnection
	login=`head -n 1 $2`
	password=`tail -n 1 $2`

	cat $file | sed -e "s/password-flags=1/password-flags=0\nusername=$login/" | sudo tee $file > /dev/null
	echo -e "[vpn-secrets]\npassword=$password" | sudo tee -a $file > /dev/null

	echo "* Open vpn credentials added"
}

restart_network_manager() {
	systemctl restart NetworkManager
	echo "* Network manager service restarted (Wait 5s)"
	sleep "5s"
}

# BEGIN

import_vpn_connection $1
create_dispatcher_file $openVpnFileName
add_vpn_credentials $openVpnFileName $2
restart_network_manager
