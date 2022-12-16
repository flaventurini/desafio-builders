#!/bin/bash

if [ $(sudo docker ps -q -f name=app-html-builders -f status=running) ]; then
    
    current_time=$(date +%d-%m-%Y_%H-%M)
    sudo echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

else
    
    cd /app-builders/app/
    sudo docker build . -t app-html-builders
    sudo docker run -dit --name app-html-builders -p 8080:80 app-html-builders

    current_time=$(date +%d-%m-%Y_%H-%M)
    sudo echo "Executada a aplicação ao dia e hora: $current_time" > /logs-app/log-${current_time}.txt

    sudo docker stop app-html-builders
    sudo docker rm app-html-builders
    
fi
