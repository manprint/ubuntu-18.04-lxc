#!/bin/bash

# container info
CONTAINER_NAME=ubuntu01-lxc
HOSTNAME=ubuntu-vm
IMAGE=adiprint/ubuntu-18.04-lxc:latest

# container memory and cpu setting (optional)
MEMORY="128M"
MEMORY_SWAP="512M"
MEMORY_SWAPPINESS="95"
CPUSET_CPUS="0"
CPUS="0.25"

# volume host definition
BIN=$(pwd)/rootfs/bin
BOOT=$(pwd)/rootfs/boot
ETC=$(pwd)/rootfs/etc
HOME=$(pwd)/rootfs/home
LIB=$(pwd)/rootfs/lib
LIB64=$(pwd)/rootfs/lib64
MEDIA=$(pwd)/rootfs/media
MNT=$(pwd)/rootfs/mnt
OPT=$(pwd)/rootfs/opt
ROOT=$(pwd)/rootfs/root
RUN=$(pwd)/rootfs/run
SBIN=$(pwd)/rootfs/sbin
SRV=$(pwd)/rootfs/srv
TMP=$(pwd)/rootfs/tmp
USR=$(pwd)/rootfs/usr
VAR=$(pwd)/rootfs/var

# volume name definition
VBIN=ubuntu01-lxc-BIN
VBOOT=ubuntu01-lxc-BOOT
VETC=ubuntu01-lxc-ETC
VHOME=ubuntu01-lxc-HOME
VLIB=ubuntu01-lxc-LIB
VLIB64=ubuntu01-lxc-LIB64
VMEDIA=ubuntu01-lxc-MEDIA
VMNT=ubuntu01-lxc-MNT
VOPT=ubuntu01-lxc-OPT
VROOT=ubuntu01-lxc-ROOT
VRUN=ubuntu01-lxc-RUN
VSBIN=ubuntu01-lxc-SBIN
VSRV=ubuntu01-lxc-SRV
VTMP=ubuntu01-lxc-TMP
VUSR=ubuntu01-lxc-USR
VVAR=ubuntu01-lxc-VAR

# volume container named
CBIN=/bin
CBOOT=/boot
CETC=/etc
CHOME=/home
CLIB=/lib
CLIB64=/lib64
CMEDIA=/media
CMNT=/mnt
COPT=/opt
CROOT=/root
CRUN=/run
CSBIN=/sbin
CSRV=/srv
CTMP=/tmp
CUSR=/usr
CVAR=/var

# volume host folder create
mkdir -p $BIN
mkdir -p $BOOT
mkdir -p $ETC
mkdir -p $HOME
mkdir -p $LIB
mkdir -p $LIB64
mkdir -p $MEDIA
mkdir -p $MNT
mkdir -p $OPT
mkdir -p $ROOT
mkdir -p $RUN
mkdir -p $SBIN
mkdir -p $SRV
mkdir -p $TMP
mkdir -p $USR
mkdir -p $VAR

# stop gracefully and clean named volume
docker exec -it $CONTAINER_NAME shutdown -h now
docker rm $CONTAINER_NAME
docker volume rm \
    $VBIN \
    $VBOOT \
    $VETC \
    $VHOME \
    $VLIB \
    $VLIB64 \
    $VMEDIA \
    $VMNT \
    $VOPT \
    $VROOT \
    $VRUN \
    $VSBIN \
    $VSRV \
    $VTMP \
    $VUSR \
    $VVAR

# note: WARNING: Your kernel does not support swap limit capabilities or the cgroup is not mounted. Memory limited without swap.
# visit: https://stackoverflow.com/questions/48685667/what-does-docker-mean-when-it-says-memory-limited-without-swap

#run
docker run -dit \
    --name=$CONTAINER_NAME \
    --hostname=$HOSTNAME \
    --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --mount type=volume,source=$VBIN,dst=$CBIN,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$BIN \
    --mount type=volume,source=$VBOOT,dst=$CBOOT,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$BOOT \
    --mount type=volume,source=$VETC,dst=$CETC,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$ETC \
    --mount type=volume,source=$VHOME,dst=$CHOME,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$HOME \
    --mount type=volume,source=$VLIB,dst=$CLIB,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$LIB \
    --mount type=volume,source=$VLIB64,dst=$CLIB64,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$LIB64 \
    --mount type=volume,source=$VMEDIA,dst=$CMEDIA,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$MEDIA \
    --mount type=volume,source=$VMNT,dst=$CMNT,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$MNT \
    --mount type=volume,source=$VOPT,dst=$COPT,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$OPT \
    --mount type=volume,source=$VROOT,dst=$CROOT,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$ROOT \
    --mount type=volume,source=$VRUN,dst=$CRUN,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$RUN \
    --mount type=volume,source=$VSBIN,dst=$CSBIN,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$SBIN \
    --mount type=volume,source=$VSRV,dst=$CSRV,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$SRV \
    --mount type=volume,source=$VTMP,dst=$CTMP,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$TMP \
    --mount type=volume,source=$VUSR,dst=$CUSR,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$USR \
    --mount type=volume,source=$VVAR,dst=$CVAR,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$VAR \
    --memory=$MEMORY \
    --memory-swap=$MEMORY_SWAP \
    --oom-kill-disable \
    --memory-swappiness=$MEMORY_SWAPPINESS \
    --cpuset-cpus=$CPUSET_CPUS \
    --cpus=$CPUS \
    $IMAGE
