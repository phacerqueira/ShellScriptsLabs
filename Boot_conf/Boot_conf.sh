#!/bin/bash

#Configuração dos logs - Descomentar para utilizar
#touch /var/log/bootscript.log
#log="/var/log/bootscript.log"

echo '===========================' # >> $log
echo '====== Início Script ======' # >> $log
echo '===========================' # >> $log

# ========= Ajsute o Hostname da máquina

sudo echo "DevOpsXperience" > /etc/hostname
sudo hostname DevOpsXperience
bash

host_name=`cat /etc/hostname | grep DevOpsXperience`

if [ -z host_name ] # valida se a variável está vazia
then
	echo 'Arquivo Hostname NÃO foi atualizado' # >> $log
	echo '===========================' # >> $log
else
	echo 'Atualizado arquivo Hostname' # >> $log
	echo '===========================' # >> $log
fi

# ========= Instalação os pacotes ntpdate e curl

sudo apt update -y

echo 'Repositórios atualizados' # >> $log
echo '===========================' # >> $log

sudo apt install curl ntpdate -y

# ========= Validando a isntalação

install_curl=`dpkg --list | grep curl | awk '{print $2}' | head -1`


	if [ -z $install_curl ]
	then
		echo "CURL não foi instalado" # >> $log
		echo '===========================' # >> $log
	else
		echo "CURL instalado com sucesso" # >> $log
		echo '===========================' # >> $log
	fi

install_ntpdate=`dpkg --list | grep ntpdate | awk '{print $2}' | head -1`

	if [ -z $install_ntpdate ]
	then
		echo "ntpdate não foi instalado" # >> $log
	else
		echo "ntpdate instalado com sucesso" # >> $log
	fi

# ========= Ajsute de data e fuso horário por NTP

sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
export TZ=America/Sao_Paulo

tz_date=`echo $TZ`

	if [ -n tz_date ] #Valida se a quantidade de caracteres na string é diferente de zero
	then
		echo "Arquivo localtime e variável TZ ajustados com sucesso" # >> $log
		echo '===========================' # >> $log
	else
		echo "Arquivo localtime e variável TZ NÃO foram ajustados" # >> $log
		echo '===========================' # >> $log
	fi

sudo ntpdate a.ntp.br

# ========= Validando o horário e data

horacerta=`date | awk '{print $5}' | grep 03`

	if [ -z horacerta]
	then
		echo "Fuso horário NÃO ajustado - verificar ntpdate e fuso horário" # >> $log
		echo '===========================' # >> $log
	else
		echo "Fuso horário ajustado para GMT -03 com sucesso" # >> $log
		date # >> $log
		echo '===========================' # >> $log

	fi

echo '===========================' # >> $log
echo '============FIM============' # >> $log
echo '===========================' # >> $log