#!/bin/bash

# Definir o IP do gateway
GATEWAY="192.168.1.1"

# Função para verificar se o gateway está ativo
check_gateway() {
    ping -c 1 $GATEWAY > /dev/null 2>&1
    return $?
}

while true; do
    check_gateway
    if [ $? -eq 0 ]; then
        # O gateway está ativo, vamos reiniciar a interface eth0
        echo "Gateway está ativo. Reiniciando a interface eth0."
        dhclient -r eth0 > /dev/null 2>&1
        dhclient eth0 > /dev/null 2>&1
        sleep 5
    else
        # O gateway não está ativo, vamos testar a cada segundo
        echo "Gateway não está ativo. Testando novamente em 1 segundo."
        sleep 1
    fi
done
