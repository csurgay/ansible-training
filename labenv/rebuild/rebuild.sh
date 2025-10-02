log() {
	printf "\n##############################\n"
	printf($1)
	printf "\n##############################\n"
	printf "\n"
}

log("### Rebuild sctipt starting")

podman rmi -fa

log("### All root images and containers removed")

podman network create ansible

log("### Podman network created")

cd ../controlnode
./build.sh

log("### Controlnode image is built")

podman tag controlnode docker.io/csurgay/controlnode:latest
podman push docker.io/csurgay/controlnode:latest

log("### Controlnode images pushed to public registry")

./run.sh

log("### Controlnode container is running")

cd ../managedhost
./build.sh

log("### Managedhost image is built")

podman tag managedhost docker.io/csurgay/managedhost:latest
podman push docker.io/csurgay/managedhost:latest

log("### Managedhost image pushed to public registry")

./run.sh

log("### Managedhost containers are running")

cd ../rebuild

podman exec ansible dnf install -y git

log("### Git is installed in Controlnode container")

podman exec -w=/root ansible git clone https://github.com/csurgay/ansible-training.git

log("### Training lab is pulled from Git to Controlnode container")

podman exec ansible dnf install -y ansible

log("### Ansible is installed in Controlnode container")

podman exec ansible bash -c 'printf "[defaults]\ninterpreter_python=auto_silent\nlog_path=ansible.log) > /root/ansible-training/labenv/ansible.cfg'

log("### Ansible config is saved in Controlnode container")

podman exec ansible bash -c 'printf "[hosts]\nhost1\nhost2\nhost3) > /root/ansible-training/labenv/inventory'

log("### Ansible Inventory is saved in Controlnode container")

for i in {1..3}; do str="$(podman network inspect ansible | grep -A5 host$i | grep ip | sed s/\ //g | sed s/.*:\"// | sed s'/\/.*//') host$i"; podman exec ansible bash -c "echo $str >> /etc/hosts"; done

log("### Managed hosts IP addresses is saved in Controlnode container")

podman exec ansible ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P ""

log("### SSH key is generated for root in Controlnode container")

podman exec ansible bash -c 'printf "root" > /root/pass'

for i in {1..3}; do podman exec ansible sshpass -f /root/pass ssh-copy-id host$i; done

log("### SSH key is copied into Managedhost containers")

podman exec ansible ansible -i /root/ansible-training/labenv/inventory hosts -m ping

log("### Ansible accessing Managedhosts is tested OK")
