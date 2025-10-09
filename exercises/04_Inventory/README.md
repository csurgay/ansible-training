# Exercise 4. Inventory

### In this exercise the following subjects will be covered:

1. Static Inventory
1. Host groups
1. Nested groups
1. Host ranges
1. Testing Inventories
1. Overriding default Inventory
1. Inventory variables
1. Dynamic Inventory

---
### Static Inventory

The most simple way to specify an inventory for ansible is a flat list of hostnames one per lines:

```
webserver1
192.168.0.2
host1.samples.com
```

---
### Host groups

Hosts can be grouped under a host group name in brackets.  
Hosts can be listed under multiple host groups.  
Ungrouped hosts of course can also be listed as before.
Ansible can than easily manage hosts of groups together.

```
192.168.0.2

[hostgroup1]
host1
host2

[webservers]
host1
server1.sample.com
server2.sample.com
```

> [!NOTE]
> There are two predefined hostgroups always present implicitly:  
> `all` refers to a flat list of all hosts listed anywhere in the Inventory  
> `ungrouped` refers to all hosts that are not listed under any hostgroups

---
### Nested groups

Using the `:children` suffix host groups can be nested under parent hostgroups.

```
[appservers]
appserver1
appserver2

[dbservers]
dbserver1
dbserver2

[servers:children]
[appservers]
[dbservers]
```

---
### Host ranges

Using the special range syntax `[begin:end]` many hosts can be specified in a single entry.

```
server_[01:12]
[a:d].sample.com
192.168.0.[2:254]
```

---
### Testing Inventories

From the previous session we know how to test inventories with ad-hoc `ansible` command and the option `--list-hosts`.

```
ansible appservers --list-hosts
ansible dnservers --list-hosts
ansible servers --list-hosts
```

---
### Overriding default Inventory

Inventory can be defined in a few ways for ansible, listed here in ascending precedence.

1. `/etc/ansible/inventory`
1. `ansible.cfg` configuration file
1. `--inventory <inventory-path>` or `-i <inventory-path>`

---
### Invetory variables

Host specific variables for playbooks can be defined directly in the Inventory file next to the host names.

```
webserver web_port=8081
host1 ansible_host=192.168.0.2
dbserver default_db=cities
```

More on this topic and best practice for ansible variables will be discussed later.

---
### Dynamic Inventory

This topic is discussed in the Automation Platform training.
