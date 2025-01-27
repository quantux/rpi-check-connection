#!/bin/bash

# Nome do container Docker que será reiniciado
CONTAINER_NAME="security_camera"

# Função para verificar a conectividade com a internet
check_internet() {
    ping -c 1 -W 1 8.8.8.8 > /dev/null
    return $?
}

# Verificar a conexão a cada X segundos
while true; do
    echo "Verificando se o container '$CONTAINER_NAME' está em execução..."

    # Verificar se o container está em execução
    if [ ! "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        echo "O container '$CONTAINER_NAME' não está em execução."

        # Verificar se há conectividade com a internet
        if check_internet; then
            echo "Conectividade com a internet verificada. Iniciando o container..."
            # Iniciar o container se a internet estiver ok
            docker run --name "$CONTAINER_NAME" --rm -d -v /home/pi/workspace/security_camera/app:/app -v /home/pi/Vídeos:/app/records -t security_camera > /dev/null 2>&1
            echo "Container '$CONTAINER_NAME' iniciado com sucesso."
        else
            echo "Sem conectividade com a internet. Não será possível iniciar o container."
        fi
    else
        echo "O container '$CONTAINER_NAME' está em execução."
    fi

    # Verificar a conexão
    echo "Verificando conectividade com a internet..."
    if ! check_internet; then
        echo "Sem conectividade com a internet. Tentando reiniciar a interface de rede..."
        # Reiniciar a interface de rede até a internet voltar
        while ! check_internet; do
            echo "Tentando obter novo IP..."
            sudo dhclient -r eth0 > /dev/null 2>&1
            sudo dhclient eth0 > /dev/null 2>&1
            sleep 1  # Aguarda antes de tentar novamente
        done

        echo "Conectividade com a internet restabelecida. Reiniciando o container..."
        # Reiniciar o container após restaurar a conexão
        docker stop "$CONTAINER_NAME" > /dev/null 2>&1
        docker run --name "$CONTAINER_NAME" --rm -d -v /home/pi/workspace/security_camera/app:/app -v /home/pi/Vídeos:/app/records -t security_camera > /dev/null 2>&1
        echo "Container '$CONTAINER_NAME' reiniciado com sucesso."
    else
        echo "Conexão com a internet está ok."
    fi

    # Aguardar antes de verificar a conexão novamente
    sleep 1
done

