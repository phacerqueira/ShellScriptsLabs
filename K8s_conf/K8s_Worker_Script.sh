#!/bin/bash

#Recomendável a execução do script Boot_conf primeiro
#Script 1 de 2 para configuação de Workers e Control Plane do Kubernetes

KUBE_VERSION="1.28.0-00"
RUN_C_VERSION="v1.1.1"
CONTAINERD_VERSION="1.7.2"

echo '==========================='
echo 'ATENÇÃO -> O SCRIPT IRÁ REINICIAR A MÁQUINA APÓS A EXECUÇÃO'
echo '==========================='

sleep 3;

echo '==========================='
echo '====== Início Script ======'
echo '==========================='

echo 'Adicionando os repositórios do Kubernetes'

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo '==========================='

sudo apt update -y

echo 'Repositórios atualizados'
echo '==========================='

sudo apt install apt-transport-https ca-certificates -y

# ========= Validando a isntalação

INSTALL_APT_TRANSPORT=`dpkg --list | grep "apt-transport-https" | awk '{print $2}' | head -1`


	if [ -z $INSTALL_APT_TRANSPORT ]
	then
		echo "apt-transport-https não foi instalado"
		echo '==========================='
	else
		echo "apt-transport-https instalado com sucesso"
		echo '==========================='
	fi

INSTALL_CERTIFICATES=`dpkg --list | grep "ca-certificates" | awk '{print $2}' | head -1`

	if [ -z $INSTALL_CERTIFICATES ]
	then
		echo "ca-certificates não foi instalado"
		echo '==========================='
	else
		echo "ca-certificates instalado com sucesso"
		echo '==========================='
	fi

echo "Desativando a SWAP e desabilitando na inicialização:"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo '==========================='

echo 'Instalação do RunC'
wget https://github.com/opencontainers/runc/releases/download/$RUN_C_VERSION/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
echo '==========================='

echo 'Criando o arquivo de configuração do ContainerD com os módulos (drivers) necessários'
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
echo '==========================='
echo 'Carregando os módulos overlay e netfilter no Kernel do linux'

sudo modprobe overlay
sudo modprobe br_netfilter

echo 'Instalando o ContainerD pelo repositório do Ubuntu'
sudo apt install -y containerd=$CONTAINERD_VERSION

INSTALL_CONTAINERD=`dpkg --list | grep "containerd" | awk '{print $2}' | head -1`

	if [ -z $INSTALL_CONTAINERD ]
	then
		echo "containerd não foi instalado"
		echo '==========================='
	else
		echo "containerd instalado com sucesso"
		echo '==========================='
	fi

echo 'Criando o diretório e gerando o arquivo de configuração padrão do ContainerD'
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sleep 3;
echo 'Ajustar o cgroup padrão do ContainerD para o SystemD:'
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
echo '==========================='

echo 'Ajustando as configurações do SystemCTL para as necessidades de rede do K8s:'
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
echo '==========================='

echo 'Instalando o Kubeadm, Kubelet e Kubectl'
sudo apt install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION

echo '==========================='

echo 'Desativando a atualização do ContainerD, Kubeadm, Kubelet e Kubectl pelo APT'

sudo apt-mark hold kubelet kubeadm kubectl containerd

echo '==========================='
echo '============FIM============'
echo '==========================='

sudo reboot;