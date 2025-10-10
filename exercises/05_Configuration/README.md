# Exercise 5. Configuration

### In this exercise the following subjects will be covered:

1. Ansible Configuration (`ansible.cfg`)
1. Location of `ansible.cfg`
1. Ansible Log

---
### Ansible Configuration (`ansible.cfg`)

A typical ansible configuration file:

```
[defaults]
remote_user = local
inventory = ./inventory
ask_pass = false
log_path = ./ansible.log
interpreter_python = /usr/bin/python3

[privilege_escalation]
become = true
become_user = root
become_ask_pass = true
become_method = sudo
```

Directives in the configuratin file above

|Directive|Semantics|
|---------|---------|
|inventory|Path to the inventory file|
|remote_user|user to log in to the managed hosts, default is current user|
|ask_pass|Asking for SSH password, false for public key authentication|
|become|Switch user on the managed host (default is root)|
|become_method|sudo is the default, su also can be used|
|become_user|Switch to this user on the managed host, default is root|
|become_ask_pass|Asking for sudo password, only one for all hosts|
|log_path|Ansible will append all output to this file|
|interpreter_python|Specifying exact location of python version suppresses warning in logs|

---
### Location of `ansible.cfg`

`ansible.cfg` can be placed in several possible locations, listed in ascending precedence.

```
/etc/ansible/ansible.cfg
~/.ansible.cfg
./ansible.cfg
export ANSIBLE_CONFIG=/home/local/ansible-training/labenv/rootless/ansible.cgf
```

The last one is best practice and have the highest precedence over all the others.

---
### Ansible Log

Ansible prints verbose output to the terminal screen, but that is hard to follow and search for.

Good practice is to specify the `log_path=./ansible.log` in the configuration so that all output is appended into a file that can later be studied, searched for, etc.

---


