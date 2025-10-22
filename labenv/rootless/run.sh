#!/bin/bash

#!/bin/bash

log() {
	if [ $? -eq 0 ]
	then
		printf "\n##################################################\n"
		printf "Success: $1"
		printf "\n##################################################\n"
		printf "\n"
	else
		printf "\n##################################################\n"
		printf "ERROR: $1"
		printf "\n##################################################\n"
		printf "\n"
		exit 1
	fi
}

log  "Rootless script started"

podman network exists ansible
if [ $? -eq 0 ]
	then echo "podman network ansible already created"
	else podman network create ansible
fi

log  "Create podman network ansible if needed"

podman rm -fa

log "All rootless containers removed"

podman run --name ansible --hostname ansible -d --network ansible docker.io/csurgay/ansible_node

log "Rootless Control Node running"

for i in {1..3}; do podman run --name host$i --privileged --hostname host$i -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 282$i:22 -p 888$i:80 --network ansible --mac-address 10:10:10:10:10:1$i docker.io/csurgay/ansible_node; done

log "Rootless Managed Hosts running"

podman exec -it ansible bash -c "useradd local"
for i in {1..3}; do podman exec -it host$i bash -c "useradd local"; done

log "User local added to all containers"

podman exec -it ansible bash -c "echo 'local:local' | chpasswd"
for i in {1..3}; do podman exec -it host$i bash -c "echo 'local:local' | chpasswd"; done

log "Password for users set up"

podman exec -it -w /home/local ansible bash -c "echo 'local ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/local"
for i in {1..3}; do podman exec -it -w /home/local host$i bash -c "echo 'local ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/local"; done

log "Local users NOPASSWD sudo granted"

podman exec -u local ansible bash -c 'ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P ""'

log "Local user ssh key in Control Node created"

podman exec -u local ansible bash -c 'printf "local" > /home/local/pass'
for i in {1..3}; do podman exec -u local ansible sshpass -f /home/local/pass ssh-copy-id host$i; done

log "SSH key is copied into Managedhost containers"

podman exec -u local -w=/home/local ansible git clone https://github.com/csurgay/ansible-training.git

log "Training lab is pulled from Git to Controlnode container"

podman cp ansible.cfg ansible:/home/local/ansible-training/labenv/rootful/

log "Ansible config is saved in Controlnode container"

podman cp host_inventory ansible:/home/local/ansible-training/labenv/rootful/

log "Ansible Inventory is saved in Controlnode container"

podman exec -it -w /home/local ansible rm -rvf ansible-training
podman exec -it -u local -w /home/local ansible git clone https://github.com/csurgay/ansible-training.git

log "Latest Ansible Training Lab cloned"

podman exec -u local -w /home/local/ansible-training/labenv/rootless ansible ansible myhosts -m ping

log "Ansible accessing Managedhosts is tested OK"

log "Entring Control Node for lessons"

podman exec -it -u local -w /home/local/ansible-training/lessons ansible /bin/bash

