#!/bin/bash

# container info
CONTAINER_NAME=ubuntu-lxc
VOL1_NAME=ubuntu-home

# stop gracefully and clean
docker exec -it $CONTAINER_NAME shutdown -h now
docker rm $CONTAINER_NAME
docker volume rm $VOL1_NAME
