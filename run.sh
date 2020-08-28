#!/bin/bash

# container info
CONTAINER_NAME=ubuntu-lxc
HOSTNAME=ubuntu
IMAGE=adiprint/ubuntu-18.04-lxc:latest

# container memory and cpu setting (optional)
MEMORY="1024M"
MEMORY_SWAP="1024M"
MEMORY_SWAPPINESS="60"
CPUSET_CPUS="0"
CPUS="0.50"

# volume host definition
VOL1_DEV=$(pwd)/rootfs/$VOL1_NAME

# volume name definition
VOL1_NAME=ubuntu-home

# volume host folder create
mkdir -p $VOL1_DEV

# volume container named
VOL1_CONT=/home/ubuntu

# stop gracefully and clean
docker exec -it $CONTAINER_NAME shutdown -h now
docker rm $CONTAINER_NAME
docker volume rm $VOL1_NAME

#run
docker run -dit \
    --name=$CONTAINER_NAME \
    --hostname=$HOSTNAME \
    --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --mount type=volume,source=$VOL1_NAME,dst=$VOL1_CONT,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$VOL1_DEV \
    --memory=$MEMORY \
    --memory-swap=$MEMORY_SWAP \
    --oom-kill-disable \
    --memory-swappiness=$MEMORY_SWAPPINESS \
    --cpuset-cpus=$CPUSET_CPUS \
    --cpus=$CPUS \
    $IMAGE
