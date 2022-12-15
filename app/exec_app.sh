#!/bin/bash

if [ $(docker ps -q -f name=app-html-builders -f status=running) ]; then
    
    echo "Já tava rodando"
    current_time=$(date +%d-%m-%Y_%H-%M)
    echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

else
    
    echo "Baixando a imagem e executando"
    docker run --name app-html-builders -it flaventurini/app-html-builders:1.0

    current_time=$(date +%d-%m-%Y_%H-%M)
    echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

    docker stop app-html-builders
    docker rm app-html-builders
    
fi

gsutil cp /logs-app/*.txt gs://bucket-devsecops-builders