# Section 1. Provisioning the Training Lab

### In this section the following subjects will be covered:

1.	Launch Ansible Control Node and three Managed Hosts in containers
2.	Set up SSH keys so that Ansible Control Node can access itself and Managed Hosts 
3.	Install and configure Ansible in the Control Node container
4.	Clone Training-Lab git repo into Ansible Control Node
5.	Smoke test Ansible to access managed hosts
6.	CLI Toolset

### Ansible Training Environment

![Figure 1. Training lab environment](https://csurgay.com/ansible/labenv.png)

---
## Launch Ansible Control Node and three Managed Hosts in containers

### Log into the builder environment

1.	Log in to the Ansible Training virtual machine called “builder”
2.	`su` yourself (or **`sudo -s`** with no root password) to privileged
3.	Make yourself nopasswd sudo by **`echo "<username> ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/<username>`**
4.	Install “git” if not already installed **`dnf -y install git`**
5.	Exit privileged by **`exit`** or (ctrl-d)
6.	Clone the Training Lab Git Repository to your local VM as your regular user into your home directory:
7.	**`git clone https://github.com/csurgay/ansible-training.git`**
8.	Change dir into the **`cd /home/<username>/ansible-training/labenv`** directory

### Build ansible image

> [!NOTE]
> This step is going to take quite a while, so it is prepared in advance. **Participants can skip this section!**

1.	cd into the “ansible_node/build_image” directory under “labenv”
2.	Run the command **`sudo ./build_image.sh`**
3.	Check the images with the command **`sudo podman images -a`**

You should see the images list:

```bash
root@builder:~/ansible-training/labenv/ansible_node/build_image$ podman images -a
REPOSITORY                         TAG         IMAGE ID      CREATED             SIZE
docker.io/csurgay/ansible_node     latest      94a737e19025  About a minute ago  1.05 GB
registry.fedoraproject.org/fedora  latest      e78db4e34c81  3 hours ago         170 MB
```

### Run the Training-Lab containers

1.	cd into the “ansible_node” directory under “labenv”
2.	Run the command **`sudo ./run_containers.sh`**
3.	Check the running container with the command **`sudo podman ps -a`**

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
## Set up SSH keys so that Ansible Control Node can access itself and Managed Hosts 

### Create `devops` user in Control Node and Managed Hosts containers

1.	Enter control node with the command **`sudo podman exec -it ansible bash`**
2.  Create `devops` user by **`adduser devops`**
3.  Add password `devops` for user `devops` by **`passwd devops`** and enter `devops` twice
4.  Add `sudo` rights to `devops` by **`echo "devops ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devops`**
5.  Exit container by **`exit`** (or ctrl-d)
6.  Repeat 1-2-3-4 for Managed Hosts by entering them **`podman exec -it host1 bash`**

### Generate devops SSH keys on Control Node

1.	Enter control node with the command **`podman exec -it -u devops ansible bash`**
2.	Generate SSH keys with the command **`ssh-keygen`**
3.	Answer with empty “Enter” to all three questions

### Copy devops SSH public keys into Control Node and Managed Hosts

1.	Still as `devops` in the Control Node container `ansible`
2.	Copy SSH key into localhost by **`ssh-copy-id host1`**
3.	No need to answer “yes” for the known_host fingerprint related question due to ssh configuration
4.	Type in root password **`devops`** when requested
5.	Repeat 2-3 for the other two magaged host containers as well

---
## Install and configure Ansible in the Control Node container

### Install ansible, git and vim

1.  Enter Ansible Control Node container `ansible` by `podman exec -it -u devops ansible bash`
2.	Run **`sudo dnf install -y ansible git vim`** on Control Node “ansible” host
3.	Test the installation with **`ansible –version`**

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
## Clone Training-Lab git repo into Ansible Control Node

1.  Enter Ansible Control Node `ansible` by **`podman -it -u devops -w /home/devops ansible bash`**
2.  Clone the Training-Lab git repo under `/home/devops` by
3.  **`git clone https://github.com/csurgay/ansible-training.git`**

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
