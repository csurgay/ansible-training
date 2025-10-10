# Exercise 6. Playbooks

### In this exercise the following subjects will be covered:

1. Playbooks Introduction
1. YAML format

---
### Playbooks Introduction

We learnt that the Ansible ad-hoc commands is a powerful tool to manipulate all kinds of states in managed hosts. But of course they can only carry out single tasks at a time. The real power of Ansible though is that complex tasks can be carried out by Playbooks. **Playbooks** can be seen as a collection of ad-hoc Ansible commands in an organized, documented, reusable manner to manipulate states of managed host. And of course Playbooks have a whole lot of other constructs and benefits to be discussed later.

Playbooks consist of muntiple **Plays**, each for a complex operation in itself, and Plays consist of **Tasks**. Tasks are the building blocks of complex operations, much like the ad-hoc commands we have seen so far.

Playbooks are written in **yaml** format, so let's go through it's basics firts.

---
### YAML format

YAML is much like JSON in terms of 
* key-value pairs
* lists
* complex constructs
* comments

| Construct | JSON | YAML (__ is TAB) |
| --------- | ---- | ---- |
| key-value pair | "key": value | key: value |
| list | ["a",1,"b"] | - "a"<br> - 1<br> - "b" |
| dict | tags:{"A": 1, "B": 2, "C": 3} | tags:<br>__A: 1<br>__B: 2<br>__C: 3 |
| comment | // comment | # comment |

A copmplete Playbook looks like the one below. `---` is the start of the Playbook: a list of Plays. Each Play starts with a dash `-` symbol to indicate list element (see table above). Similarly `tasks:` of a Play is list of Tasks, so each Task starts with the dash `-` symbol.

```
---
# This is a comment in the sample Playbook

- name: First Play of this Playbook
  hosts: webservers
  become: true
  gather_facts: false

  tasks:
    - name: Firts Task is to install nginx
      ansible.builtin.package:
        name: nginx
        state: latest

    - name: Second Task is to start nginx
      ansible.builtin.systemd:
        name: nginx
        state: started
        enabled: true

- name: Second Play of this Playbook
  hosts: localhost
  become: false
  gather_facts: false

  tasks:
    - name: Test nginx on one webserver
      ansible.builtin.command:
        cmd: curl http://webserver:80
