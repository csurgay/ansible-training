# Exercise 3. Ansible Ad-Hoc Commands - Solutions

This document provides solutions to the exercises from the **Exercise 3. Ansible Ad-Hoc Commands** guide.  
Each solution shows the actual command(s) to run.

---

### 1. Testing Connectivity (`ping`)
**Exercise Solutions:**
- Run the ping command on all hosts:
```
ansible all -m ping
````

* Run it on a specific group or host:

```
ansible webservers -m ping
```

---

### 2. Running Commands (`command` and `shell`)

**Exercise Solutions:**

* Display the system’s uptime:

```
ansible all -m command -a "uptime"
```

* Check the current user’s home directory:

```
ansible all -m shell -a "echo $HOME"
```

---

### 3. File Transfer (`copy` and `fetch`)

**Exercise Solutions:**

* Copy a local script to `/usr/local/bin`:

```
ansible all -m copy -a "src=myscript.sh dest=/usr/local/bin mode=0755"
```

* Fetch `/etc/os-release` into `/tmp/`:

```
ansible all -m fetch -a "src=/etc/os-release dest=/tmp/ flat=yes"
```

---

### 4. Package Management (`yum` / `apt`)

**Exercise Solutions:**

* Install `git` on all hosts:

```
ansible all -m yum -a "name=git state=present"
```

* Remove `nginx` from a specific host:

```
ansible web1 -m apt -a "name=nginx state=absent" --become
```

---

### 5. Managing Services (`service` / `systemd`)

**Exercise Solutions:**

* Start `httpd` or `nginx`:

```
ansible all -m service -a "name=httpd state=started"
```

* Enable the service on boot:

```
ansible all -m systemd -a "name=httpd enabled=yes"
```

---

### 6. User and Group Management (`user` / `group`)

**Exercise Solutions:**

* Create a user `ansibleuser`:

```
ansible all -m user -a "name=ansibleuser state=present"
```

* Delete the `devops` group:

```
ansible web1 -m group -a "name=devops state=absent"
```

---

### 7. File Permissions (`file`)

**Exercise Solutions:**

* Create a directory `/opt/ansible` with `0750`:

```
ansible all -m file -a "path=/opt/ansible state=directory mode=0750"
```

* Remove `/tmp/testdir`:

```
ansible all -m file -a "path=/tmp/testdir state=absent"
```

---

### 8. Gathering Facts (`setup`)

**Exercise Solutions:**

* Gather all facts:

```
ansible all -m setup
```

* Show only OS information:

```
ansible all -m setup -a "filter=ansible_distribution*"
```

---

### 9. Rebooting Hosts (`reboot`)

**Exercise Solutions:**

* Reboot all hosts:

```
ansible all -m reboot --become
```

* Test if they’re back online:

```
ansible all -m ping
```

---

### 10. Parallelism and Limits (`fork`)

**Exercise Solutions:**

* Run a command on just 1 host:

```
ansible web1 -m shell -a "date"
```

* Run `ping` on all hosts with `-f 5`:

```
ansible all -m ping -f 5
```

---

### Final Multi-Step Task Solutions

1. Ping all hosts:

```
ansible all -m ping
```

2. Install `nginx`:

```
ansible all -m apt -a "name=nginx state=present" --become
```

3. Copy a custom index.html:

```
ansible all -m copy -a "src=index.html dest=/usr/share/nginx/html/index.html mode=0644"
```

4. Start and enable `nginx`:

```
ansible all -m systemd -a "name=nginx state=started enabled=yes"
```

5. Verify service is running:

```
ansible all -m shell -a "curl -s http://localhost"
```
