#!/bin/bash

# Defina o gateway e a interface
GATEWAY="192.168.1.1"
INTERFACE="eth0"  # Substitua por sua interface de rede, se necessário

# Função para verificar a conectividade com o gateway
check_gateway() {
    ping -c 1 "$GATEWAY" > /dev/null 2>&1
    return $?
}

while true; do
    if check_gateway; then
        echo "Gateway está ativo. Verificando novamente em 1 segundo..."
        sleep 1
    else
        # Se o gateway não estiver ativo, reinicia a interface de rede e testa a conexão novamente
	dhclient -r "$INTERFACE" > /dev/null 2>&1
	dhclient "$INTERFACE" > /dev/null 2>&1
    fi
done

