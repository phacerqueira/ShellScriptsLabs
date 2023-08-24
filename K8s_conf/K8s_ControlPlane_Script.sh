#!/bin/bash

#Script 2 de 2 para configuação do Control Plane do Kubernetes

echo '==========================='
echo 'ATENÇÃO -> CERTIFIQUE-SE DE TER EXECUTADO O SCRIPT WORKER PRIMEIRO'
echo '==========================='

sleep 3;

echo '==========================='
echo '====== Início Script ======'
echo '==========================='

echo 'Criando autocomplete e alias para o Kubectl'
sudo echo 'complete -F __start_kubectl k' >> ~/.bashrc
sudo echo 'source <(kubectl completion bash)' >> ~/.bashrc
sudo echo "alias k='kubectl'" >> ~/.bashrc
source ~/.bashrc

echo '==========================='

echo 'Iniciando o Cluster com a rede 192.168.0.0/16'
sudo kubeadm init --pod-network-cidr 192.168.0.0/16

echo '==========================='
echo 'ATENÇÃO -> CERTIFIQUE-SE DE COPIAR O COMANDO JOIN PARA AS MÁQUINAS WORKER'
echo '==========================='
sleep 8;

echo 'Gerando configuração do Kubernetes para o Kubectl'
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo '==========================='

echo 'Instalando o AddOn de redes Calico-Networking ao Cluster'

sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml

echo 'Validando a instalação do Calico-Networking'

sudo kubectl get pods -n calico-system -o wide

echo '==========================='
echo '============FIM============'
echo '==========================='

sudo reboot;