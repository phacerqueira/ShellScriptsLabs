# Script para automação da instalação e configuração de um Cluster Kubernetes

- Supõe-se que foi executado o script Boot_conf
- Não é necessário instalar o Docker
- Será instalado nesta ordem -> RunC -> ContainerD -> Kubeadm -> Kubelet + Kubectl
- Executar primeiro o script [K8s_Worker](K8s_conf/K8s_Worker_Script.sh)
- No Control Plane executar o script [K8s_ControlPlane](K8s_conf/K8s_ControlPlane_Script.sh)
- Caso não tenha copiado o comando Join fornecido pelo init do Cluster, utilizar o comando abaixo
  - kubeadm token create --print-join-command
- Este script foi idealizado para facilitar a instalação e configuração de um Cluster Kubernetes simples. Para configurar um Cluster no modelo de Alta Disponibilidade (2 Control Planes + Load Balancer), verificar a documentação do Kubernetes.