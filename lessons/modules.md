# Ansible modules

## Some frequently used Modules

|Category|Module|Description|
|---------------|------|-----------|
|Files modules|copy|Copy a local file to the managed host|
||file|Set permissions and other properties of files|
||lineinfile|Ensure a particular line is or is not in a file|
||synchronize|Synchronize content using rsync|
|Package modules|package|Autodetected package manager|
||yum|YUM package manager|
||apt|APT package manager|
||dnf|DNF package manager|
||gem|Manage Ruby gems|
||pip|Manage Python packages from PyPI|
|System modules|firewalld|Ports and services management|
||reboot|Reboot a machine|
||service|Manage services|
||user|Add, remove, and manage user accounts|
|Net Tools modules|get_url|Download files over HTTP, HTTPS, or FTP|
||nmcli|Manage networking|
||uri|Interact with web services|

---
## Usage of Modules

### File Module

#### Create directory

```
- name: Create a log directory
  file:
    path: /var/log/myapp
    state: directory
    mode: '0755'
```

This makes a directory at /var/log/myapp with standard permissions. Run it again? No problem—it won’t redo what’s already there.

#### Delete file

```
- name: Delete an old log
  file:
    path: /var/log/old.log
    state: absent
```

### Package (dnf) Module

#### Installing Nginx

```
- name: Install Nginx
  dnf:
    name: nginx
    state: present
```

This checks if Nginx is installed and adds it if not. 

#### Update all

```
- name: Update all packages
  dnf:
    name: "*"
    state: latest
```

### Service Module

#### Start and enable Nginx

```
- name: Start and enable Nginx
  service:
    name: nginx
    state: started
    enabled: yes
```

#### Quick restart

```
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

### User Module

#### Create user

```
- name: Add Sarah with sudo
  user:
    name: sarah
    state: present
    groups: wheel
    shell: /bin/bash
```

#### Remove user

```
- name: Remove Sarah
  user:
    name: sarah
    state: absent
```

### Template Module

#### Deploy Nginx config

```
- name: Set up Nginx config
  template:
    src: /path/to/nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
```

This uses a template file (.j2) and restarts Nginx if it changes.

---
## Advanced Module Usage

### Looping Over Tasks

Install multiple packages at once with a loop:

```
- name: Install several packages
  package:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl
```

This installs all three in one shot.

### Waiting for Something

```
- name: Wait for port 80 to be open
  wait_for:
    port: 80
    state: started
```

This waits until port 80 is active.

### Checking Conditions

Run a task only if something’s true:

```
- name: Restart if needed
  service:
    name: nginx
    state: restarted
  when: restart_needed
```

This restarts `nginx` only if `restart_needed` is true.

---
## Best Practices for Using Ansible Modules

### Name Your Tasks, Plays, Playbooks

Task name is optional, but it is a good idea to always name your tasks using the name attribute. It will also make reading and debugging your playbooks much more convenient. When you execute a playbook, Ansible displays the name of the task that it is executing, and you can search for these names in long logs.

### Use Variables

Avoid hardcoded values in your playbooks. Rather than doing it, use variables. To give a specific example, rather than hardcoding a username of Dave in the application, you can use a variable such as `{{ developer_user }}`. This makes your playbooks more reusable and flexible.

### Check for existing modules 

Before you consider writing a custom module, always check in Ansible Galaxy to see whether someone has done one similar to what you need.

### Read documentation

Each Ansible module has documentation on how to use all of its options and examples as well. When you open a new module, spend some time reading the documentation. It will prevent you from tons of headaches later. `ansible-doc <module_name>` will give you the documentation of any module on your command line.
