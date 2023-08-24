#!/bin/bash

#Variável para log - Para gravar o log em arquivo basta descomentar a gravação
#touch /var/log/docker_conf.log
#log="/var/log/docker_conf.log"

# ========= Instalação do Docker

curl -sSL https://get.docker.com | bash
echo 'Instalado Docker' # >> $log
echo '===========================' # >> $log

# ========= Validando instalação do Docker

install_docker=`dpkg --list | grep docker | awk '{print $2}' | head -1`

	if [ -z $install_docker ]
	then
		echo "docker NÃO foi instalado" # >> $log
		echo '===========================' # >> $log
	else
		echo "docker instalado com sucesso" # >> $log
		echo '===========================' # >> $log
	fi

# ========= Iniciando o Docker

sudo systemctl start docker.service

docker_ativo=`sudo systemctl status docker.service | grep Active`

	if [ -z docker_ativo]
	then
		echo 'docker.service NÃO foi ativado' 
		echo '===========================' # >> $log
	else
		echo 'docker.service ativado' # >> $log
		echo '===========================' # >> $log
	fi

# ========= Adicionando usuario ubuntu no grupo Docker

sudo usermod -aG docker ubuntu

grupo_docker=`cat /etc/group | grep "docker.*ubuntu"`

	if [-z grupo_docker ]
	then
		echo 'Usuario Ubuntu NÃO FOI adicionado no grupo Docker' # >> $log
		echo '===========================' # >> $log
	else
		echo 'Usuario Ubuntu adicionado no grupo Docker' # >> $log
		echo '===========================' # >> $log
	fi

# ========= Criando o Container NGNIX

sudo docker run --name DevOpsLabs -p 80:80 -d nginx
echo 'Iniciado Container NGINX' # >> $log

# ========= Validando a criação do Container NGNIX

cont_nginx=`docker container ls | grep -i nginx`

if [ -z cont_nginx ]
then
	echo 'Erro ao criar Container NGNIX' # >> $log
	echo '===========================' # >> $log
else
	echo 'Container NGNIX criado com sucesso' # >> $log
	echo '===========================' # >> $log
fi

echo '===========================' # >> $log
echo '============FIM============' # >> $log
echo '===========================' # >> $log