# Exercise 1. Provisioning the Training Lab

### In this exercise the following subjects will be covered:

1.	Launh Ansible control node and three managed hosts in containers
2.	Set up SSH keys so that Ansible can access managed hosts 
3.	Install and configure Ansible in the control node container
4.	Test Ansible to access managed hosts

### Ansible Training Environment

![Figure 1. Training lab environment](https://csurgay.com/ansible/ansible-labenv.png)

## 1. Launching the Ansible Training Environment

### Log into the builder environment

1.	Log in to the Ansible Training virtual machine called “builder” as root
2.	Install “git” if not already installed **`dnf -y install git`**
3.	Clone the Training Lab Git Repository to your local VM:
4.	**`git clone https://github.com/csurgay/ansible-training.git`**
5.	cd into the “ansible-training/labenv” directory in root’s home

### Build ansible “control node” image

1.	cd into the “controlnode” directory under “labenv”
2.	Run the command **`./build.sh`**
3.	It is going to take some time, ca. 1-2 minutes
4.	Check the images with the command **`podman images -a`**

### Run the “control node” container

1.	Run the command **`./run.sh`** in the same “controlnode” directory
2.	Check the running container with the command **`podman ps -a`**

### Build ansible “managed host” image

1.	cd into the “managedhost” directory under “labenv”
2.	Run the command **`./build.sh`**
3.	Check the images with the command **`podman images -a`**

### Run the “managed host” containers

1.	Run the command **`./run.sh`** in the same “managedhost” directory
2.	Check the output IP and MAC addresses, they should all be different
3.	Make note of the 3 IP addresses, we will need them later (e.g. 10.88.0.11, 12, 13)
4.	Check the running containers with the command **`podman ps -a`**

## 2. Setting up SSH keys

### Generate SSH keys on “controlnode”

1.	Enter control node with the command **`podman exec -it ansible bash`**
2.	Generate SSH keys with the command **`ssh-keygen`**
3.	Answer with empty “Enter” to all three questions

### Copy public ssh keys into managed hosts

1.	Issue the command **`ssh-copy-id 10.88.0.11`**
2.	Answer “yes” for the known_host fingerprint related question
3.	Type in root password **`root`** when requested
4.	Repeat 2 and 3 for the other two magaged host containers as well

## 3. Install and configure Ansible on control node

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

## 4. Test ansible access managed hosts

### Ad-hoc command for testing

1.	Test python version on Control node:
2.	**`ansible localhost -m setup | grep python_version`** 
1.	Test that ansible can manage the hosts with the ping module as follows:
1.	**`ansible myhosts -m ping`**
1.	Check ansible output for all three pong responses
