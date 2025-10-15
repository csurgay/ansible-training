# Container based Ansible bootcamp

Date Created: 2025-09-01  
Last Modified: 2025-10-14  
Contact: csurgay@gmail.com  

This is the first complete Ansible traning laboratory where Containers are managed instead of resource consuming VMs.

It is not uncommon for Ansible to run in a container based Control Node. But to manage Containers as Managed hosts is a different matter. Not to mention that Playbooks of the usual Ansible training materials are not easy to run in Containers. Pre-requisites include the ability to `ssh` into the Managed Host Containers. Also, Ansible system and service modules require `systemd` to run inside the Managed Host Containers.

### Benefits of a Container based Ansible bootcamp

First of all, it can be set up and run in a singe host or VM, because the Control Node and Managed Hosts are containerized from pre-build images by a quick and simple command script. So there is no need for a bunch of VMs per participants like in Red Hat training labs. Footprint of HW requirements is mininal, a cheap low capacity laptop is sufficient. 

On the other hand, pre-designed environments for different exercises can also be quickly set up as containers. This further simplifies the bootcamp setup. There is no need for pre-exercise "lab scripts". Participants can also compare or work on multiple lessons at the same time, as they are lightweight Container environments.

### Container based Ansible Training Lab

<img width="674" height="332" alt="ansible-labenv" src="https://github.com/user-attachments/assets/aba470de-6a9a-409c-996d-b90dbf5fa05c" />

---
# Usage

### 1. Clone and build the Training Lab

Log in to any Red Hat based linux or VM as root, then:

```
# Install Git and Podman
dnf install -y git podman

# Clone the Git repo on the Host VM
git clone https://github.com/csurgay/ansible-training.git

# Run the Lab Containers and enter the Control Node (ansible)
cd ansible-training/labenv/rootless
./run.sh
```

### 2. Test the Training Lab

On the Control Node (ansible)
```
ansible all -m ping
```

### 3. Read and follow the lessons material

Numbered GitHub lesson directories under `ansible-training/lessons`

### 4. Hands-on exercises

Enter the Ansible Control Node Container (ansible) and run the exercise commands and playbooks

```
podman exec -it -u local -w /home/local/ansible-training/labenv ansible /bin/bash
```
