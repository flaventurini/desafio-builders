#!/bin/bash

echo "Atualizando e instalação o sistema..."

sudo apt-get update && sudo apt-get install -y

echo "Instalando docker..."

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Criando pasta de Logs..."

mkdir /logs-app
sudo chmod u+x ~/desafio-builders/app/exec_app.sh

echo "Pronto!"
