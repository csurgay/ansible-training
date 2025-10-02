echo "##### Rebuild sctipt starting"

podman rmi -fa

echo "### All root images and containers removed"

podman network create ansible

echo "### Podman network created"

cd ../controlnode
./build.sh

echo "### Controlnode image build"

podman tag controlnode docker.io/csurgay/controlnode:latest
podman push docker.io/csurgay/controlnode:latest

echo "### Controlnode images pushed to public registry"

./run.sh

echo "### Controlnode container is running"

cd ../managedhost
./build.sh

echo "### Managedhost image built"

podman tag managedhost docker.io/csurgay/managedhost:latest
podman push docker.io/csurgay/managedhost:latest

echo "### Managedhost image pushed to public registry"

./run.sh

echo "### Managedhost containers are running"

cd ../rebuild

podman exec ansible dnf install -y git

echo "### Git is installed in Controlnode container"

podman exec -w=/root ansible git clone https://github.com/csurgay/ansible-training.git

echo "### Training lab is pulled from Git to Controlnode container"

podman exec ansible dnf install -y ansible

echo "### Ansible is installed in Controlnode container"

podman exec ansible bash -c 'printf "[defaults]\ninterpreter_python=auto_silent\nlog_path=ansible.log\n" > /root/ansible-training/labenv/ansible.cfg'

echo "### Ansible config is saved in Controlnode container"

podman exec ansible bash -c 'printf "[hosts]\nhost1\nhost2\nhost3\n" > /root/ansible-training/labenv/inventory'

echo "### Ansible Inventory is saved in Controlnode container"

for i in {1..3}; do str="$(podman network inspect ansible | grep -A5 host$i | grep ip | sed s/\ //g | sed s/.*:\"// | sed s'/\/.*//') host$i"; podman exec ansible bash -c "echo $str >> /etc/hosts"; done

echo "### Managed hosts IP addresses is saved in Controlnode container"

podman exec ansible ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P ""

echo "SSH key is generated for root in Controlnode container"

podman exec ansible bash -c 'printf "root" > /root/pass'

for i in {1..3}; do podman exec ansible sshpass -f /root/pass ssh-copy-id host$i; done

echo "### SSH key is copied into Managedhost containers"

podman exec ansible ansible -i /root/ansible-training/labenv/inventory hosts -m ping

echo "### Ansible accessing Managedhosts is tested OK"

