# Containerized Ansible Training Lab

|           |            |
|-----------|------------|
| Purpose | Single host full Ansible training lab (lessons and exercises) |
| Audience | Future DevOps engineers new to Ansible |
| Prerequisites | Linux, any scripting experience |
| Control Node | Containerized Ansible execution environment on a host or VM |
| Managed Hosts | Dozens of containerized Linux servers on the same sigle host |
| Training Lab | Fully automated setup and real playbook exercises |
| Versions | Ansible core 2.18, Python 3.13, Jinja 3.1, Podman 5.4, Git 2.51, Fedora 42, Linux 6.14 |
| Date Created | 2025-09-01 |
| Last Modified | 2025-10-24 |
| Contact | csurgay@gmail.com |
| Author | Father of three, Red Hat Certified Engineer, Red Hat Certified Instructor |

In the first complete **Containerized Ansible Traning Lab** there are lightweight containers for both the Ansible Control Node, and the dozens of Managed Host Linux servers. This is new to earlier Labs, where heavyweight VMs were used and only a few fix hosts were available to be managed by exercises. This containerized approach allows for a **high degree of flexibility**. Both the Control Node and Managed Hosts can be preconfigured for the execrcises learning goals. Recontainerization is seamless for participants and all the benefits of containerization contribute to a **steeper learning curve**. These benefits are exclusive environments for different exercise subjects, encapsulation of required dependencies, portability on operating systems, isolated exercise testing, easier management.

For the Control Node to run in a container is not uncommon. But for **Ansible to manage containers as Managed Hosts** is a different matter. Exercise Playbooks to be executed on Containerized Managed Hosts have unobvious conditions. These include e.g. the ability to `ssh` into the Managed Host containers. Ansible system and service modules require `systemd` to run inside the Managed Host containers. In order for system hardware related modules like chrony to work porperly, special privileges, so called system capablities are required in containers. 

### Benefits of a Container based Ansible bootcamp

First of all, it can be set up and run in a singe host or VM, because the Control Node and Managed Hosts are containerized from pre-build images by a quick and simple command script. So there is no need for a bunch of VMs per participants like in Red Hat training labs. Footprint of HW requirements is mininal, a cheap low capacity laptop is sufficient. 

On the other hand, pre-designed environments for different exercises can also be quickly set up as containers. This further simplifies the bootcamp setup. There is no need for pre-exercise "lab scripts". Participants can also compare or work on multiple lessons at the same time, as they are lightweight Container environments.

### Container based Ansible Training Lab

![Figure 1. Training lab environment](https://csurgay.com/ansible/labenv.png)

---
# Usage

### 1. Clone and build the Training Lab

Log in to any Red Hat based host or VM, then:

```
# Install Git and Podman
sudo dnf install -y git podman

# Clone the Git repo on the Host VM
git clone https://github.com/csurgay/ansible-training.git

# Run the Lab Containers and enter the Control Node (ansible)
cd ansible-training/labenv/
sudo ./run.sh
```

### 2. Test the Training Lab

In the `labenv` direcotory of the Ansible Control Node container 'ansible'
```
cd /home/devops/ansible-training/labenv
ansible all -m ping
```

### 3. Read and follow the lessons material

Numbered GitHub lesson directories under `ansible-training/lessons`

### 4. Hands-on exercises

Enter the Ansible Control Node Container (ansible) and run the exercise commands and playbooks

```
sudo podman exec -it -u devops -w /home/devops/ansible-training/lessons ansible /bin/bash
```

