#!/bin/bash

echo "remove all container..."
docker rm $(docker ps -qa)


echo "remove all images..."
docker rmi $(docker images -q ghcr.io/modulehandbook/modulehandbook)


sudo rm container_logs/*.log
sudo rm container_logs/nginx/*.log
