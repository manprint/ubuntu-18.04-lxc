#!/bin/bash

docker build --compress --force-rm --squash --tag adiprint/ubuntu-18.04-lxc:latest .
echo y | docker image prune
