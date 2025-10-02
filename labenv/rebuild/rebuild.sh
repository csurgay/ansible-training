podman rmi -fa

podman network create ansible

cd ../controlnode
./build.sh
podman tag controlnode docker.io/csurgay/controlnode:latest
podman push docker.io/csurgay/controlnode:latest
./run.sh

cd ../managedhost
./build.sh
podman tag managedhost docker.io/csurgay/managedhost:latest
podman push docker.io/csurgay/managedhost:latest
./run.sh

cd ../rebuild

podman exec ansible dnf install -y git
podman exec -w=/root ansible git clone https://github.com/csurgay/ansible-training.git
podman exec ansible dnf install -y ansible

podman exec ansible bash -c 'printf "[defaults]\ninterpreter_python=auto_silent\nlog_path=ansible.log\n" > /root/ansible-training/labenv/ansible.cfg'

podman exec ansible bash -c 'printf "[hosts]\nhost1\nhost2\nhost3\n" > /root/ansible-training/labenv/inventory'

for i in {1..3}; do str="$(podman network inspect ansible | grep -A5 host$i | grep ip | sed s/\ //g | sed s/.*:\"// | sed s'/\/.*//') host$i"; podman exec ansible bash -c "echo $str >> /etc/hosts"; done

podman exec ansible ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -P ""

podman exec ansible bash -c 'printf "root" > /root/pass'

for i in {1..3}; do podman exec ansible sshpass -f /root/pass ssh-copy-id host$i; done

podman exec ansible ansible -i /root/ansible-training/labenv/inventory hosts -m ping

