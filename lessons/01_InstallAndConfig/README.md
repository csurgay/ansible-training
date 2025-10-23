# Section 1. Provisioning the Training Lab

### In this section the following subjects will be covered:

1.	Launch Ansible control node and three managed hosts in containers
2.	Set up SSH keys so that Ansible can access managed hosts 
3.	Install and configure Ansible in the control node container
4.	Smoke test Ansible to access managed hosts
5.	CLI Toolset

### Ansible Training Environment

![Figure 1. Training lab environment](https://csurgay.com/ansible/ansible-labenv.png)

---
## Launching the Ansible Training Environment

### Log into the builder environment

1.	Log in to the Ansible Training virtual machine called “builder” as root
2.	Install “git” if not already installed **`dnf -y install git`**
3.	Clone the Training Lab Git Repository to your local VM:
4.	**`git clone https://github.com/csurgay/ansible-training.git`**
5.	cd into the “ansible-training/labenv” directory in root’s home

### Build ansible image

1.	cd into the “ansible_node/build_image” directory under “labenv”
2.	Run the command **`./build_image.sh`**
3.	It is going to take some time
4.	Check the images with the command **`podman images -a`**

You should see the images list:

```bash
root@builder:~/ansible-training/labenv/ansible_node/build_image$ podman images -a
REPOSITORY                         TAG         IMAGE ID      CREATED             SIZE
docker.io/csurgay/ansible_node     latest      94a737e19025  About a minute ago  1.05 GB
registry.fedoraproject.org/fedora  latest      e78db4e34c81  3 hours ago         170 MB
```

### Run the Training-Lab containers

1.	cd into the “ansible_node” directory under “labenv”
2.	Run the command **`./run_containers.sh`**
3.	Check the running container with the command **`podman ps -a`**

You should see the list of containers in `Up` state

```bash
root@builder:~/ansible-training/labenv/ansible_node$ podman ps -a
CONTAINER ID  IMAGE                                  COMMAND         CREATED         STATUS         PORTS                                               NAMES
51d0ad5445c6  docker.io/csurgay/ansible_node:latest  /usr/sbin/init  12 seconds ago  Up 13 seconds  0.0.0.0:2020->22/tcp, 22/tcp                        ansible
bcec1e67c6f3  docker.io/csurgay/ansible_node:latest  /usr/sbin/init  12 seconds ago  Up 12 seconds  0.0.0.0:2021->22/tcp, 0.0.0.0:8081->80/tcp, 22/tcp  host1
affd78f71de7  docker.io/csurgay/ansible_node:latest  /usr/sbin/init  11 seconds ago  Up 12 seconds  0.0.0.0:2022->22/tcp, 0.0.0.0:8082->80/tcp, 22/tcp  host2
8ae3f09469ac  docker.io/csurgay/ansible_node:latest  /usr/sbin/init  11 seconds ago  Up 12 seconds  0.0.0.0:2023->22/tcp, 0.0.0.0:8083->80/tcp, 22/tcp  host3
```

---
## Setting up SSH keys

### Generate SSH keys on “controlnode”

1.	Enter control node with the command **`podman exec -it ansible bash`**
2.	Generate SSH keys with the command **`ssh-keygen`**
3.	Answer with empty “Enter” to all three questions

### Copy public ssh keys into managed hosts

1.	Issue the command **`ssh-copy-id 10.88.0.11`**
2.	Answer “yes” for the known_host fingerprint related question
3.	Type in root password **`root`** when requested
4.	Repeat 2 and 3 for the other two magaged host containers as well

---
## Install and configure Ansible on control node

### Install ansible and vim

1.	Run **`dnf install -y ansible`** on control node “ansible” host as root
2.	Test the installation with **`ansible –version`**
3.	Install Vim editor for coloring of playbooks **`dnf install -y vim`**

### Configure Ansible

1.	Create a textfile named **`hosts_inventory`** with the three IP addresses e.g. as follows:
```
[myhosts]
10.88.0.11
10.88.0.12
10.88.0.13
```

2.	Create a textfile named **`ansible.cfg`**

It will contain the reference for the default inventory,
a reference for the log_path to log all ansible output to,
and suppress a python related warning for conveniance.

```
[defaults]
inventory=./hosts_inventory
log_path=ansible.log
interpreter_python=/usr/bin/python3
```

---
## Smoke test ansible access managed hosts

### Ad-hoc command for testing

1.	Test python version on Control node:
2.	**`ansible localhost -m setup | grep python_version`** 
1.	Test that ansible can manage the hosts with the ping module as follows:
1.	**`ansible myhosts -m ping`**
1.	Check ansible output for all three pong responses

---
## CLI toolset

There are other CLI tools than `ansible` installed from the package, see the list below. Some
of them can also be used for smoke testing or quickly query or manage a single aspect of target 
hosts without writing a full Playbook.

| CLI tool | Purpose |
|----------|---------|
| ansible | Runs single Task on managed hosts (aka ad-hoc command ) |
| ansible-config | View, init, validate an Ansible Configuration |
| ansible-console | Interactive Ansible command interpreter |
| ansible-doc | Modules and Plugins documentation tool (snippet|
| ansible-galaxy | Roles and Collections related operations |
| ansible-inventory | View actual Inventory groups, hosts, and variables |
| ansible-playbook | Run Playbook on managed hosts |
| ansible-pull | Pulls Playbook from git repo and runs on managed hosts |
| ansible-vault | Secret variable and file encryption automatism for Playbooks |

### Testing the tools

A few typical uses of the other CLI tools:

- `ansible-config view`
- `ansible-config validate`
- `ansible-config list | grep -A6 LOG_PATH`
- `ansible-console all`
  - ```
    list
    list goups
    ping
    help ansible.builtin.debug
    command date
    command hostname
    become true
    dnf name=sl state=present
    set_fact alma=2kg
    debug var=alma
    gather_facts
    debug var=ansible_facts.os_family
    ```
- `ansible-doc debug`
- `ansible-doc --snippet debug`
- `ansible-galaxy role install system`
- `ansible-galaxy role list`
- `ansible-inventory --list --vars`
- `ansible-inventory --graph`
- `ansible-playbook --inventory targethosts --become --aks-become-pass myplaybook.yml`
- `ansible-pull -U https://github.com/user/myansible myplaybook.yml`
- `ansible-vault view --vault-id=@prompt mysecret.yml`
