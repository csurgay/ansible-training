# Exercise 3. Ansible Ad-Hoc Commands

### In this exercise the following steps will be cerried out:

1. Testing Connectivity (`ping`)
2. Running Commands (`command` and `shell`)
3. File Transfer (`copy` and `fetch`)
4. Package Management (`yum` / `apt`)
5. Managing Services (`service` / `systemd`)
6. User and Group Management (`user` / `group`)
7. File Permissions (`file`)
8. Gathering Facts (`setup`)
9. Rebooting Hosts (`reboot`)
10. Parallelism and Limits (`fork`)
11. Final Exercise: Multi-Step Task

## Ad-Hoc commands

Ansible **Ad-Hoc commands** are simple, one-liner commands that allow you to quickly perform tasks on managed hosts  
**without writing a playbook**. They are useful for quick testing, troubleshooting, or executing tasks across multiple systems.

Ad-Hoc commands are executed with the **`ansible`** command-line tool and generally follow this structure:

```
ansible <host-pattern> -m <module> -a "<module-options>"
````

* **`<host-pattern>`** → Specifies target hosts (from the inventory).
* **`-m <module>`** → Defines the module to use (e.g., `ping`, `shell`, `copy`).
* **`-a "<module-options>"`** → Provides arguments to the module.

---

## Commonly Used Ansible Ad-Hoc Modules

### 1. Testing Connectivity (`ping`)

```
ansible all -m ping
```

Checks if hosts are reachable.

**Exercise:**

* Run the ping command on all hosts.
* Run it on a specific group or host.

---

### 2. Running Commands (`command` and `shell`)

* **`command` module** → Runs commands without using a shell.
* **`shell` module** → Runs commands through a shell (`/bin/sh`).

```
ansible all -m command -a "uptime"
ansible all -m shell -a "echo $HOME"
```

**Exercise:**

* Use `command` to display the system’s uptime.
* Use `shell` to check the current user’s home directory.

---

### 3. File Transfer (`copy` and `fetch`)

* **Copy files to remote hosts**:

```
ansible all -m copy -a "src=/etc/hosts dest=/tmp/hosts_backup"
```

* **Fetch files from remote hosts**:

```
ansible all -m fetch -a "src=/etc/hosts dest=/tmp/hosts"
```

**Exercise:**

* Copy a local script to `/usr/local/bin` on all hosts.
* Fetch `/etc/os-release` from all hosts into `/tmp/`.

---

### 4. Package Management (`yum` / `apt`)

```
ansible all -m yum -a "name=git state=present"
ansible all -m apt -a "name=nginx state=latest" --become
```

**Exercise:**

* Install `git` on all hosts.
* Remove `nginx` from a specific host.

---

### 5. Managing Services (`service` / `systemd`)

```
ansible all -m service -a "name=nginx state=started"
ansible all -m systemd -a "name=nginx enabled=yes state=stopped"
```

**Exercise:**

* Start `httpd` or `nginx` service on all hosts.
* Enable the service to auto-start on boot.

---

### 6. User and Group Management (`user` / `group`)

```
ansible all -m user -a "name=deploy state=present"
ansible all -m group -a "name=devops state=absent"
```

**Exercise:**

* Create a user `ansibleuser` on all hosts.
* Delete the `devops` group from one host.

---

### 7. File Permissions (`file`)

```
ansible all -m file -a "path=/tmp/testdir state=directory mode=0755"
```

**Exercise:**

* Create a directory `/opt/ansible` with `0750` permissions.
* Remove `/tmp/testdir`.

---

### 8. Gathering Facts (`setup`)

```
ansible all -m setup
ansible all -m setup -a "filter=ansible_distribution*"
```

**Exercise:**

* Gather all facts from a host.
* Filter facts to show only OS-related information.

---

### 9. Rebooting Hosts (`reboot`)

```
ansible all -m reboot --become
```

**Exercise:**

* Reboot all hosts and wait for them to come back.
* Test if they are online with `ping`.

---

### 10. Parallelism and Limits (`fork`)

* Run against **specific number of hosts**:

```
ansible all -m ping --limit web1
```

* Control **parallelism** with `-f` (forks):

```
ansible all -m ping -f 10
```

**Exercise:**

* Run a command on just 1 host.
* Run `ping` on all hosts with `-f 2`.

---

### 11. Final Exercise: Multi-Step Task

1. Ping all hosts.
2. Install `nginx` package.
3. Copy a custom index.html to `/usr/share/nginx/html/`.
4. Start and enable the `nginx` service.
5. Verify service is running with `curl localhost`.

---
> [!TIP]
> With ad-hoc commands, you can quickly **test, configure, and troubleshoot** systems.
> For more complex workflows, you’ll want to use **Ansible Playbooks**.

