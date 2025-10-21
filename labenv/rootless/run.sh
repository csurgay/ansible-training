#!/bin/bash

echo "### Create podman network ansible if needed"

podman network exists ansible
if [ $? -eq 0 ]
	then echo "podman network ansible already created"
	else podman network create ansible
fi

echo "### Run rootless Control Node"

podman run --name ansible --hostname ansible -d --network ansible docker.io/csurgay/rootless_controlnode

echo "### Run rootless Managed Hosts"

for i in {1..3}; do podman run --name host$i --privileged --hostname host$i -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 282$i:22 -p 888$i:80 --network ansible --mac-address 10:10:10:10:10:1$i docker.io/csurgay/rootless_managedhost; done

echo "### Clone latest Ansible Training Lab"

podman exec -it -w /home/local ansible rm -rvf ansible-training
podman exec -it -u local -w /home/local ansible git clone https://github.com/csurgay/ansible-training.git

echo "### Enter Control Node for lessons"

podman exec -it -u local -w /home/local/ansible-training/lessons ansible /bin/bash

