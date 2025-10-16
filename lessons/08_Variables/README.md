# Section 8. Variables

---
### In this section the following subjects will be covered

1. Variable names
1. Usage
1. Registered variables
1. Nested (complex) variables
1. Variable Precedence
1. Magic variables

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
### Nested (complex) varaibles

If a query or calculation returns nested (complex) object in a variable, the structure can be unnested if two ways:

+ Bracket notation (`ansible_facts['python']['version']['major']`)
+ Dot notation (`ansible_facts.python.version.major`)

---
### Variable Precedence

> [!WARNING]
> Variables with the same name can be defined in 20+ different places of the Ansible ecosystem. They will override each other according to their location, according to Variable Precedence.

> [!TIP]
> Keep it simple. Define variables in only one place, thus avoid Ansible Precedence.


Variables can be defined in several places, e.g:

+ Roles
+ Inventory
+ Playbooks/Plays
+ Include files
+ Command line

Ansible will load each and override the ones with the same names, thus Precedence is applied.

#### Inventory variables

Precedence from lowest to highest:

- `all`
- parent group
- child group
- host

```
washington

[france]
paris myvar:host_highest

[germany]
hamburg
hannover

[europe:children]
france
germany

[europe:vars]
myvar: child_group

[china]
beijing
shanghai

[asia:children]
china

[world:children]
europe
asia

[world:vars]
myvar: parent_group

[all:vars]
myvar: all_lowest
```

#### In yaml format

`ansible-inventory -i ./world_inventory --list --yaml`

```
all:
  children:
    ungrouped:
      hosts:
        washington:
          myvar: all_lowest
    world:
      children:
        asia:
          children:
            china:
              hosts:
                beijing:
                  myvar: parent_group
                shanghai:
                  myvar: parent_group
        europe:
          children:
            france:
              hosts:
                paris:
                  myvar: host_highest
            germany:
              hosts:
                hamburg:
                  myvar: child_group
                hannover:
                  myvar: child_group
```

#### In JSON format

`ansible-inventory -i ./world_inventory --list`

```
{
    "_meta": {
        "hostvars": {
            "beijing": {
                "myvar": "parent_group"
            },
            "hamburg": {
                "myvar": "child_group"
            },
            "hannover": {
                "myvar": "child_group"
            },
            "paris": {
                "myvar": "host_highest"
            },
            "shanghai": {
                "myvar": "parent_group"
            },
            "washington": {
                "myvar": "all_lowest"
            }
        }
    },
    "all": {
        "children": [
            "ungrouped",
            "world"
        ]
    },
    "asia": {
        "children": [
            "china"
        ]
    },
    "china": {
        "hosts": [
            "beijing",
            "shanghai"
        ]
    },
    "europe": {
        "children": [
            "france",
            "germany"
        ]
    },
    "france": {
        "hosts": [
            "paris"
        ]
    },
    "germany": {
        "hosts": [
            "hamburg",
            "hannover"
        ]
    },
    "ungrouped": {
        "hosts": [
            "washington"
        ]
    },
    "world": {
        "children": [
            "europe",
            "asia"
        ]
    }
}
```

#### Play variables

```
---
- name: Play variable illustration
  hosts: all
  gather_facts: false
  vars:
    myvariable: "Something for this Play only"
    another: 1234
```

#### Included variables

```
---
- name: Include vars_files illustration
  hosts: all
  gather_facts: false
  vars:
    hardcoded: "here"
  vars_files:
    - /vars/reusable_variables.yml
    - /vars/another_varfile.yml
```

#### Format of var_files

```
---
# Variables for use in multiple Plays
myvariable: "Reusable string"
another: 1234
```

#### Precedence of variable locations

1. Role defaults
1. Inventory file group_vars
1. Inventory group_vars
1. Playbook group_vars
1. Inventory file host_vars
1. Inventory host_vars
1. Playbook host_vars
1. Play vars
1. Play vars_files
1. Role vars
1. Task vars
1. Include_vars
1. Registered vars and set_facts
1. Role params
1. Runtime extra vars (--extra-vars "var1=John var2=123")

```
ansible_project/
├─ ansible.cfg
├─ inventory_file
│  ├─ **group_vars**
│  ├─ **host_vars**
├─ inventory/
│  ├─ **group_vars/**
│  ├─ **host_vars/**
│  ├─ prod.ini
|  |  ├─ **group_vars**
|  |  └─ **host_vars**
│  ├─ test.ini
│  └─ dev.ini
├─ **group_vars/** (Playbook)
|  └─ myhosts
├─ **host_vars/** (Playbook)
|   ├─ host1
|   └─ host2
├─ playbook1.yml
|   ├─ Play **vars**
|   ├─ Play **vars_files**
|   ├─ Block **vars**
|   ├─ Task **vars**
|   ├─ Include **vars**
|   ├─ Registered **vars**
|   └─ set_facts **vars**
├─ playbook2.yml
└─ roles/ - **role_params**
   ├─ mariadb/
   |  ├─ **defaults/main.yml**
   |  ├─ **vars/main.yml**
   |  ├─ templates/main.yml
   |  └─ tasks/main.yml
   └─ nginx/
      ├─ defaults/main.yml
      ├─ vars/main.yml
      ├─ templates/main.yml
      └─ tasks/main.yml
```

> [!NOTE]
> The above directory layout is best practice, where Playbooks are mappings of a set Roles to a set of Inventory.

> [!WARNING]
> The sheer number of locations for Variable definitions are impossible keep track of.

> [!TIP]
> Avoid Precedence conflicts by planning Variable placement and name Variables differently if possible.

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
















