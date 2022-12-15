#!/bin/bash

if [ $(docker ps -q -f name=app-html-builders -f status=running) ]; then
    
    current_time=$(date +%d-%m-%Y_%H-%M)
    echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

else
    
    sudo docker build /app-builders/desafio-builders/app -t app-html-builders
    docker run --name app-html-builders -it app-html-builders

    current_time=$(date +%d-%m-%Y_%H-%M)
    echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

    docker stop app-html-builders
    docker rm app-html-builders
    
fi

gsutil cp /logs-app/*.txt gs://bucket-devsecops-builders