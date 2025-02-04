#!/bin/bash

# Definir o IP do gateway
GATEWAY="192.168.1.1"

# Função para verificar se o gateway está ativo
check_gateway() {
    ping -c 1 -W 1 $GATEWAY > /dev/null 2>&1
    return $?
}

while true; do
    check_gateway
    if [ $? -ne 0 ]; then
        # O gateway não está acessível, reiniciando a interface eth0
        echo "Gateway inacessível. Reiniciando a interface eth0."
        sudo ip link set eth0 down
        sleep 2
        sudo ip addr flush dev eth0  # Remove qualquer IP atribuído
        sudo ip link set eth0 up
        sleep 2
        sudo dhclient -r eth0
        sudo dhclient eth0
        sleep 10  # Espera um pouco antes de testar novamente
    else
        echo "Gateway acessível. Próxima verificação em 30 segundos."
        sleep 30
    fi
done

