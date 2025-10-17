# Section 12. Control Flow

### In this section the following subjects will be covered:

1. Conditions
1. Logical operators
1. Loops

---
## Conditions

### Variable as Condition

```
---
- name: Variable as Condition
  hosts: host1
  vars:
    weather: good # or bad

 tasks:

   - name: task, based on my_mood var
     ansible.builtin.debug:
       msg: "Yay! We go hiking!"
     when: weather == "good"

   - name: task, based on my_mood var
     ansible.builtin.debug:
       msg: "Staying home to play chess!"
     when: weather == "bad"
```

### Fact as Condition
```
---
- name: Fact as Condition
  hosts: host1

  tasks:

    - name: Install httpd
      ansible.builtin.package:
        name: httpd
        state: latest
      when: ansible_distribution == 'RedHat'

    - name: Install apache
      ansible.builtin.package:
        name: apache2
        state: latest
      when: ansible_distribution == 'Debian' or
            ansible_distribution == 'Ubuntu'
```

### Registered as Condition
```
---
- name: Registered as Condition
  hosts: host1

  tasks:

    - name: Ensure nginx is present
      ansible.builtin.package:
        name: nginx
        state: latest
      register: install_nginx_results

    - name: Restart nginx only if needed
      ansible.builtin.service:
        name: nginx
        state: restarted
      when: install_nginx_result.changed
```

### Roles Conditions
```
---
- name: Roles Conditions
  hosts: all
  roles:
    - role: nginx
      when: "'webservers' in group_names"
    - role: mariadb
      when: "'databases' in group_names"
```

---
## Logical operators

### AND, OR, NOT

```
when: one is "1" and two is "2"
```

```
when:
  - one is "1"
  - two is "2"
```

```
- name: Illustration for NOT operator
  hosts: all
  tasks:
    - name: Check mountpoint exists
      stat:
        path: "{{ mountpoint }}"
      register: mountpoint_stat

    - name: Create mountpoint
      file:
        path: "{{ mountpoint }}"
        state: directory
        mode: 755
      when: not mountpoint_stat.stat.exists
```

---
## Loops

### Variable list Loops
```
---
- name: Variable list Loops
  hosts: host1
  become: true

  tasks:

    - name: Install list of packages
      ansible.builtin.package:
        name: “{{ item }}”
        state: present
      loop:
        - git
        - podman
        - vim
```

### Combining Loops and Conditions
```
---
- name: Combining Loops and Conditions
  hosts: all # webservers and databases
  vars:
    apps:
      - name: httpd
        hostgroups: ['webservers']
      - name: mariadb
        hostgroups: ['databases']
      - name: git
        hostgroups: ['webservers', 'databases']

  tasks:

    - name: Deploy packages based on hostgroup
      package:
        name: "{{ item.name }}"
        state: latest
      when: group_names[0] in item.hostgroups
      loop: "{{ apps }}"
```

### Loop through Inventory
```
---
- name: Loop through Inventory
  ansible.builtin.debug:
    msg: "{{ item }} : {{ hostvars[item].group_names[0] }}"
  loop: "{{ groups['all'] }}"
```


