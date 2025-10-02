printf "\n##### Rebuild sctipt starting\n\n"

podman rmi -fa

printf "\n### All root images and containers removed\n\n"

podman network create ansible

printf "\n### Podman network created\n\n"

cd ../controlnode
./build.sh

printf "\n### Controlnode image is built\n\n"

podman tag controlnode docker.io/csurgay/controlnode:latest
podman push docker.io/csurgay/controlnode:latest

printf "\n### Controlnode images pushed to public registry\n\n"

./run.sh

printf "\n### Controlnode container is running\n\n"

cd ../managedhost
./build.sh

printf "\n### Managedhost image is built\n\n"

podman tag managedhost docker.io/csurgay/managedhost:latest
podman push docker.io/csurgay/managedhost:latest

printf "\n### Managedhost image pushed to public registry\n\n"

./run.sh

printf "\n### Managedhost containers are running\n\n"

cd ../rebuild

podman exec ansible dnf install -y git

printf "\n### Git is installed in Controlnode container\n\n"

podman exec -w=/root ansible git clone https://github.com/csurgay/ansible-training.git

printf "\n### Training lab is pulled from Git to Controlnode container\n\n"

podman exec ansible dnf install -y ansible

printf "\n### Ansible is installed in Controlnode container\n\n"

podman exec ansible bash -c 'printf "[defaults]\ninterpreter_python=auto_silent\nlog_path=ansible.log\n\n" > /root/ansible-training/labenv/ansible.cfg'

printf "\n### Ansible config is saved in Controlnode container\n\n"

podman exec ansible bash -c 'printf "[hosts]\nhost1\nhost2\nhost3\n\n" > /root/ansible-training/labenv/inventory'

printf "\n### Ansible Inventory is saved in Controlnode container\n\n"

for i in {1..3}; do str="$(podman network inspect ansible | grep -A5 host$i | grep ip | sed s/\ //g | sed s/.*:\"// | sed s'/\/.*//') host$i"; podman exec ansible bash -c "printf $str >> /etc/hosts"; done

printf "\n### Managed hosts IP addresses is saved in Controlnode container\n\n"

podman exec ansible ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P ""

printf "\nSSH key is generated for root in Controlnode container\n\n"

podman exec ansible bash -c 'printf "root" > /root/pass'

for i in {1..3}; do podman exec ansible sshpass -f /root/pass ssh-copy-id host$i; done

printf "\n### SSH key is copied into Managedhost containers\n\n"

podman exec ansible ansible -i /root/ansible-training/labenv/inventory hosts -m ping

printf "\n### Ansible accessing Managedhosts is tested OK\n\n"

