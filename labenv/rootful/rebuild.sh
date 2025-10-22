#!/bin/bash

log() {
	if [ $? -eq 0 ]
	then
		printf "\n##########################################\n"
		printf "Success: $1"
		printf "\n##########################################\n"
		printf "\n"
	else
		printf "\n##########################################\n"
		printf "ERROR: $1"
		printf "\n##########################################\n"
		printf "\n"
		exit 1
	fi
}

log "Rebuild sctipt starting"

podman rmi -fa

log "All root images and containers removed"

podman network list | grep ansible
if [ $? -gt 0 ]
then
	podman network create ansible
fi

log "Podman network created"

cd ../controlnode
./build.sh

log "ansible_node image is built"

podman push docker.io/csurgay/ansible_node

log "ansible_node image is pushed to public registry"

