#!/bin/bash

if [ $(docker ps -qa) == ""]; then
    echo no container
else
    echo "remove all container..."
    docker rm $(docker ps -qa)
fi

if [ $(docker images -qa) == ""]; then
    echo no images
else
    echo "remove all images..."
    docker rmi $(docker images -qa)
fi
