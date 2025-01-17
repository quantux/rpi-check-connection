#!/bin/bash
if ! ping -c 1 -W 1 8.8.8.8 > /dev/null; then
        echo "Conexão perdida. Tentando reconectar..."
        sudo dhclient -r eth0
	sudo dhclient eth0
fi
