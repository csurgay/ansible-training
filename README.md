# Container based Ansible bootcamp

Date Created: 2025-09-01  
Last Modified: 2025-10-14  
Contact: csurgay@gmail.com  

This is the first complete Ansible traning laboratory where Containers are managed instead of resource consuming VMs.

It is not uncommon for Ansible to run in a container based Control Node. But to manage Containers as Managed hosts is a different matter. Not to mention that Playbooks of the usual Ansible training materials are not easy to run in Containers. Pre-requisites include the ability to `ssh` into the Managed Host Containers. Also, Ansible system and service modules require `systemd` to run inside the Managed Host Containers.

### Benefits of a Container based Ansible bootcamp

First of all, it can be set up and run in a singe host or VM, because the Control Node and Managed Hosts are containerized from pre-build images by a quick and simple command script. So there is no need for a bunch of VMs per participants like in Red Hat training labs. Footprint of HW requirements is mininal, a cheap low capacity laptop is sufficient. 

On the other hand, pre-designed environments for different exercises can also be quickly set up as containers. This further simplifies the bootcamp setup. There is no need for pre-exercise "lab scripts". Participants can also compare or work on multiple lessons at the same time, as they are lightweight Container environments.

---
# Usage

### 1. Clone and build the Training Lab Exvirment

Log in to any Red Hat based linux or VM as root, then:

```
dnf install -y git podman
git clone https://github.com/csurgay/ansible-training.git
cd ansible-training/labenv/rebuild
./rebuild.sh
podman exec -it -u local -w /home/local/ansible-training/labenv ansible /bin/bash
```

### 2. Read lessons material

Numbered GitHub lesson directories under `ansible-training/lessons`

### 3. Hands-on exercises

Work in the Ansible Control node Container

```
podman exec -it -u local -w /home/local/ansible-training/labenv ansible /bin/bash
```
