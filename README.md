Este repositório é usado para verificar a conexão no raspberry pi.

O único script que existe verifica pela conexão, e se não houver nenhuma, ele reinicia a interface de rede. Isso faz o raspberry pi tentar a reconexão.

Deve-ser colocar o script no crontab no modo root para que execute a cada minuto, dessa forma:
* * * * * /home/rpi/workspace/rpi-check-connection/rpi-check-connection.sh

