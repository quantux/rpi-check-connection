#!/bin/bash

# Nome do container Docker que será reiniciado
CONTAINER_NAME="security_camera"

# Função para verificar a conectividade com a internet
check_internet() {
    ping -c 1 -W 1 8.8.8.8 > /dev/null
    return $?
}

# Verificar a conexão a cada 5 segundos
while true; do
    if ! check_internet; then
        # Reiniciar a interface de rede até a internet voltar
        while ! check_internet; do
            sudo dhclient -r eth0 > /dev/null 2>&1
            sudo dhclient eth0 > /dev/null 2>&1
            sleep 5  # Aguarda 5 segundos antes de tentar novamente
        done

        # Reiniciar o container Docker
        docker stop "$CONTAINER_NAME" > /dev/null 2>&1
        docker run --name "$CONTAINER_NAME" --rm -d -v /home/pi/workspace/security_camera/app:/app -v /home/pi/Vídeos:/app/records -t security_camera > /dev/null 2>&1
    fi

    # Aguardar 5 segundos antes de verificar a conexão novamente
    sleep 5
done
