# Section 8. Variables

---
### In this section the following subjects will be covered

1. Variuable names
1. Usage
1. Registered variables
1. Precedence of locations (selected)
1. Tips for variable locations
1. Magic variables

---
> [!WARNING]
> Variables with the same name can be defined in 20+ different places of the Ansible ecosystem. They will override each other according to their location, aka Variable Precedence.

> [!TIP]
> Keep it simple. Define variables in only one place, thus avoid Ansible Precedence.

---
### Variable names

+ Only letters, numbers and unserscores
+ Cannot redifine keywords and internal variables
+ Cannot start with number

---
### Usage

#### Define

```
my_var: 123
other: "string with spaces"
path_variable: /etc/ansible/hosts
list_var:
  - first
  - second
  - third
dictionary:
  name: John
  born: 1970
```

#### Reference (Jinja2 syntax)

```
message: Value of other is {{ other }}.
quoted_if_starts_with: "{{ my_var }}"
list_item: "{{ list_var[0] }}"
str: "{{ dictionary['name'] }}:{{ dictionary['born'] }}"

# Value of other is string with spaces.
# 123
# first
# John:1970
```

---
### Registered variables

Output of an Ansible Task can saved into variables (registering into variables). The `register: <var>` keyword is used. These newly created variables can later be tested for the success or the result of a Task's execution.

```
- name: Illustration of register
  ansible.builtin.command:
    cmd: date
  register: date_result
```

---
### Precedence of locations (selected)

1. Role defaults
1. Inventory group_vars
1. Playbook group_vars
1. Inventory host_vars
1. Playbook host_vars
1. Play vars
1. Role vars
1. Task vars
1. include_vars
1. Registered vars and set_facts
1. Role params
1. include params
1. Extra vars (for example, -e "user=my_user")

```
project/
├─ inventory/
│  ├─ hosts.ini
│  ├─ group_vars/
│  │  └─ webservers.yml
│  └─ host_vars/
│     └─ host1.example.com.yml
├─ playbook.yml
├─ play_group_vars/
│  └─ webservers.yml        # "Playbook group_vars" example
├─ play_host_vars/
│  └─ host1.example.com.yml # "Playbook host_vars" example
└─ roles/
   └─ myrole/
      ├─ defaults/main.yml
      ├─ vars/main.yml
      └─ tasks/main.yml
```


---
### Tips for variable locations

- Set variables in inventory that deal with geography or behavior

---
### Magic variables

Magic variables are automatically set by Ansible and can be used to get information specific to a particular managed host.

#### Most used Magic variables :

| Magic variable | Description |
|----------------|-------------|
| **`hostvars`** | Used to get another managed host's variables. Includes facts after `gather_facts=true` |
| **`group_names`** | All the groups the current managed host is member of |
| **`groups`** | All ths groups and hosts of the current inventory |
| **`inventory_hostname`** | Hostname of the current managed host from the inventory. This may be different from the host name reported by facts for various reasons. |

#### Usage examples

```
ansible host1     -m debug -a 'var=hostvars["host2"]'
ansible host2     -m debug -a 'var=hostvars'
ansible all       -m debug -a 'var=hostvars.host3.ansible_version.string'
ansible host1     -m debug -a 'var=group_names'
ansible localhost -m debug -a 'var=groups'
ansible host1     -m debug -a 'var=inventory_hostname'
```




