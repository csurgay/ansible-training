# Section ??. Roles

### In this section the following subjects will be covered:

1. Introduction to Roles
1. Roles Directory Structure
1. Roles Locatinos

---
## Introduction to Roles

Roles are shareable and reusable Ansible operations that follow a predefined directory structure of Ansible artifacts (task, vars, templates, handlers, tests, resource files, etc).

Roles can be called from your Playbooks, and can be given parameters specific to your application.

---
## Roles Directory Structure
```
roles/
    myrole1/              # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks, can include other task files
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for template module
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            mytext.txt    #  <-- files to copy
            myscript.sh   #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables for this role
        defaults/         #
            main.yml      #  <-- default variables for this role, low precedence
        meta/             #
            main.yml      #  <-- role dependencies
```

---
### Roles Locations

Roles can be placed in the `roles/` subdirctory relative to the Playbook file, or at the `roles_path` config key locations with it's default values:

- `~/.ansible/roles`
- `/usr/share/ansible/roles`
- `/etc/ansible/roles`

