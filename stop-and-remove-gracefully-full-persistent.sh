#!/bin/bash

# container to remove
CONTAINER_NAME=ubuntu01-lxc

# volume name to remove
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

# stop gracefully and clean
docker exec -it $CONTAINER_NAME shutdow -h now
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
