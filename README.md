# ansible-training

## Ansible Training lab and exercises

Date Created: 2025-09-01  
Last Modified: 2025-10-06  
Author: csurgay@gmail.com  

Ansible bootcamp from ad-hoc, playbooks, and roles to galaxy, navigator and gitops.

## Usage

### 1. Clone and build the Training Lab Exvirment

Log in to any Red Hat based linux or VM as root, then:

```
dnf install -y podman
git clone https://github.com/csurgay/ansible-training.git
cd ansible-training/labenv/rebuild
./rebuild.sh
podman exec -it ansible bash
```

### 2. Follow the exercises on GitHub dirs

### 3. Work in the ansible control node container

```
podman exec -it ansible.bash
```
