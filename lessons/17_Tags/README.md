# Section 17: Tags

#### In this section the following subjects will be covered

1. Understanding Ansible tags
1. How to use tags
1. List all tags
1. Multiple tags
1. Skip tags
1. `always` and `never`
1. Advanced tag usage
1. Best practices for using tags in Ansible
1. Ansible tags in real-world examples

---
## Understanding Ansible tags?

Ansible tags let you control exactly which tasks, roles, or plays run in a playbook. You add tags in the YAML playbook file and assign them to a task or a role. When you run ansible-playbook with the --tags option, only the tasks with those tags will run, and everything else will be skipped.

This is useful when you don’t want to run the entire playbook but only certain parts. It helps prevent unwanted changes or disruptions in your systems.

Why not just use conditionals? Conditionals only run a task if a specific condition is true. Tags give you more control because you can run the task directly from the command line, no matter the conditions.

#### Benefits of Using Tags

Easier debugging – If something is not working, you can add a tag to the task you want to test. Running only that tag helps you find the problem without executing the whole playbook.

Flexible execution – Tags allow you to skip tasks that might cause issues during a particular run.

Reuse tasks – You can run the same tasks or roles in different situations by using tags, making your playbooks more efficient.

---
## Usage of Tags

Now that we understand why tags are useful, let’s look at some examples. You can add tags to tasks, roles, or plays in your playbook.

#### Adding a Tag to a Task

In this example, we add tags to tasks that install and start the Apache web server:

```yaml
---
- name: Apache Setup
  hosts: test
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
      tags: install_apache

    - name: Start Apache Service
      service:
        name: apache2
        state: started
      tags: start_service
```

#### To run only the Install Apache task, use:

```bash
ansible-playbook playbook.yml --tags "install_apache"
```

#### To run only the Start Apache task, use:

```bash
ansible-playbook playbook.yml --tags "start_service"
```

#### Adding a Tag to a Role

Tags work the same way for roles. Here’s an example:

```yaml
---
- name: Role Playbook
  hosts: test
  roles:
    - role: standard_linux_package
      tags: standard_package

    - role: tomcat_app
      tags: tomcat
```

#### To run only the Tomcat role and skip the standard Linux package role, use:
```bash
ansible-playbook playbook.yml --tags "tomcat"
```

---
## List all tags

When your playbook has many tasks or roles, it can be hard to know which tags are used where. Listing all tags helps you see which tasks, roles, or plays can be run or skipped individually.

You can do this using the --list-tags option with the ansible-playbook command.

#### Example playbook:
```yaml
---
- name: Apache Setup
  hosts: test
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
      tags:
        - install

    - name: Start Apache Service
      service:
        name: apache2
        state: started
      tags:
        - start

    - name: Configure Apache
      template:
        src: apache.conf.j2
        dest: /etc/apache2/apache2.conf
      tags:
        - configure
```

#### To list all the tags in this playbook, run:
```bash
ansible-playbook apache-playbook.yml --list-tags
```

#### The output will show all the tasks and their tags, for example:
```
playbook: apache_playbook.yml

  play #1 (all): Apache    TAGS: []
    task #1: Install Apache    TAGS: [install]
    task #2: Start Apache Service    TAGS: [start]
    task #3: Configure Apache    TAGS: [configure]
```

This makes it easy to know which tags you can run or skip when executing your playbook.

---
## Multiple tags

You can assign more than one tag to tasks, roles, or plays in a playbook. This makes your playbook more flexible and gives you better control over what runs.

Multiple tags are useful when tasks belong to different groups. For example, you might want some tasks to be part of a “web server” group and others part of a “database” group, while still keeping tags for specific actions like install, start, or configure.

#### Example: Grouping Tasks with Multiple Tags
```yaml
---
- name: MyWebApp Setup
  hosts: test
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
      tags:
        - install
        - webserver

    - name: Install MySQL
      apt:
        name: mysql-server
        state: present
      tags:
        - install
        - database

    - name: Configure Apache
      template:
        src: apache.conf.j2
        dest: /etc/apache2/apache2.conf
      tags:
        - configure
        - webserver

    - name: Configure MySQL
      template:
        src: my.cnf.j2
        dest: /etc/mysql/my.cnf
      tags:
        - configure
        - database

    - name: Start Apache Service
      service:
        name: apache2
        state: started
      tags:
        - start
        - webserver

    - name: Start MySQL Service
      service:
        name: mysql
        state: started
      tags:
        - start
        - database
```

#### Run all install tasks:
```bash
ansible-playbook myapp.yml --tags "install"
```

#### Run only web server tasks:
```bash
ansible-playbook myapp.yml --tags "webserver"
```

#### Run only database tasks:
```bash
ansible-playbook myapp.yml --tags "database"
```

#### You can also skip certain tags when running a playbook:
```bash
ansible-playbook example_playbook.yml --skip-tags "configure"
```

This allows you to run only the tasks you need without affecting others.

---
## Skip tags

Sometimes you may want to skip certain tasks while letting the rest of your playbook run. By using the --skip-tags option, you can omit specific tasks during execution.

#### Example: Skipping a Task During Deployment

Suppose you want to apply configuration changes without restarting the service:
```yaml
---
- name: Update Configuration
  hosts: all
  tasks:
    - name: Apply new configuration
      template:
        src: new_config.j2
        dest: /etc/myapp/config.conf
      tags: update_config

    - name: Restart myapp service
      service:
        name: myapp
        state: restarted
      tags: restart_service
```

#### Run this command to skip restarting the service:
```bash
ansible-playbook update_config.yml --skip-tags "restart_service"
```

#### Example: Skipping Tasks in Specific Environments

Tags can also help when deploying to different environments (dev, QA, UAT, prod). You can skip certain tasks in non-development environments:
```yaml
---
- name: App Deployment
  hosts: all
  tasks:
    - name: Install dependencies
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - curl
      tags: install_dependencies

    - name: Deploy application code
      git:
        repo: 'https://github.com/me/app.git'
        dest: /var/www/myapp
      tags: deploy_code

    - name: Configure application
      template:
        src: app_config.j2
        dest: /etc/myapp/config.conf
      tags:
        - configure_app
        - skip_in_production

    - name: Restart application service
      service:
        name: app
        state: restarted
      tags:
        - restart_service
        - skip_in_production

    - name: Run database migrations
      command: /usr/local/bin/migrate_db.sh
      tags:
        - migrate_db
        - skip_in_production
```

#### Inventory file example:
```yaml
[dev]
dev.app.com

[qa]
qa.app.com

[uat]
uat.app.com

[production]
prod.app.com
```

#### To run the playbook only in non-dev environments while skipping certain tasks:
```bash
ansible-playbook manage_app.yml --limit production --skip-tags "skip_in_production"
ansible-playbook manage_app.yml --limit qa --skip-tags "skip_in_production"
ansible-playbook manage_app.yml --limit uat --skip-tags "skip_in_production"
```

The --skip-tags flag gives you flexibility to control exactly which tasks run in each environment.

---
## `always` and `never`

Ansible has two special tags that help keep your playbooks consistent and safe:

always: This tag ensures a task runs every time, no matter what other tags are used on the command line. Use it for critical checks, environment setup, or cleanup tasks that must always run.

never: This tag ensures a task never runs, regardless of other tags. It is useful for deprecated tasks or for temporarily disabling tasks during testing or debugging.

#### Example: Always Run Cleanup Tasks

This playbook deploys the application and config, but always deletes temporary files, no matter which tag is used:
```yaml
---
- name: App Deployment
  hosts: all
  tasks:
    - name: Deploy application
      git:
        repo: 'https://github.com/app/myapp.git'
        dest: /var/www/myapp
      tags: deploy_code

    - name: Configure application
      template:
        src: app_config.j2
        dest: /etc/myapp/config.conf
      tags: configure_app

    - name: Cleanup temporary files
      file:
        path: /tmp/myapp_temp
        state: absent
      tags: always
```

#### Example: Never Run Deprecated Tasks

If a task is deprecated, you can use the never tag to prevent it from running, even if someone uses its tag:
```yaml
---
- name: Update Database Schema
  hosts: db_servers
  tasks:
    - name: Backup database
      command: /usr/local/bin/db_backup.sh
      tags: db_backup

    - name: Update database schema (deprecated)
      command: /usr/local/bin/db_update.sh
      tags:
        - db_update
        - never

    - name: Reboot database server
      reboot:
      tags: reboot_db
```

#### Example: Using Always and Never Together

You can use always and never in the same playbook without conflicts:
```yaml
---
- name: Deploy Application
  hosts: all
  tasks:
    - name: Validate environment
      command: /usr/local/bin/validate_env.sh
      tags: always

    - name: Deploy application
      git:
        repo: 'https://github.com/app/myapp.git'
        dest: /var/www/myapp
      tags: deploy_app

    - name: Deprecated deployment step
      command: /usr/local/bin/deprecated_deploy.sh
      tags:
        - deprecated
        - never

    - name: Cleanup environment
      command: /usr/local/bin/cleanup_env.sh
      tags: always
```

This ensures that important tasks always run, and deprecated tasks never run, giving you more control and stability in your playbook.

---
## Advanced tag usage

Ansible tags can be used in more advanced ways with variables, facts, roles, and imports to make your playbooks more flexible and efficient.

#### Using Tags with Variables

You can assign tag values through variables so that all your tag management is centralized instead of scattered across the playbook.
```yaml
---
- name: Playbook with Tags and Variables
  hosts: all
  vars:
    install_tag: "install_apache"

  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
      tags: "{{ install_tag }}"
```

You can also trigger variables only when their associated tag is used. For example, we can set web_server_port to apply only when the webserver tag is called, and db_server_port only when the dbserver tag is used:
```yaml
- hosts: all
  vars:
    web_server_port: 80
    db_server_port: 5432

  tasks:
    - name: Install web server
      tags: webserver
      yum:
        name: httpd
        state: present

    - name: Start web server
      tags: webserver
      service:
        name: httpd
        state: started

    - name: Configure web server port
      tags: webserver
      lineinfile:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^Listen '
        line: "Listen {{ web_server_port }}"
        notify: restart webserver

    - name: Install database server
      tags: dbserver
      yum:
        name: postgresql-server
        state: present

    - name: Start database server
      tags: dbserver
      service:
        name: postgresql
        state: started

    - name: Configure database server port
      tags: dbserver
      lineinfile:
        path: /var/lib/pgsql/data/postgresql.conf
        regexp: '^port = '
        line: "port = {{ db_server_port }}"
        notify: restart dbserver

  handlers:
    - name: restart webserver
      service:
        name: httpd
        state: restarted

    - name: restart dbserver
      service:
        name: postgresql
        state: restarted
```

#### Using Tags with Facts

Ansible facts are system details collected from managed nodes. By default, facts are gathered at the start of every playbook, but this can slow down execution. You can use tags to gather facts only when needed.
```yaml
---
- name: Gather facts with tags
  hosts: all
  gather_facts: false
  tasks:
    - name: Gather facts
      setup:
      tags: gather_facts

    - name: Install Apache on Debian
      apt:
        name: apache2
        state: present
      when: ansible_facts['os_family'] == "Debian"
      tags:
        - install_apache

    - name: Install Apache on CentOS
      yum:
        name: httpd
        state: present
      when: ansible_facts['os_family'] == "RedHat"
      tags:
        - install_apache
```

#### You can also conditionally gather facts for specific environments:
```yaml
---
- name: Gather facts in non-production
  hosts: all
  gather_facts: false
  tasks:
    - name: Gather facts in non-prod
      setup:
      tags: gather_facts_non_prod
      when: env != "production"

    - name: Deploy application
      git:
        repo: 'https://github.com/example/myapp.git'
        dest: /var/www/myapp
      tags: deploy_app
```

#### Inventory example:
```ini
[development]
dev.company.com env=development

[production]
prod.company.com env=production
```

#### Command to run only on the dev environment:
```bash
ansible-playbook deployment_playbook.yml --tags "gather_facts_non_prod,deploy_app"
```

#### Using Tags with Roles and Imports

You can also tag roles and imported tasks to control exactly which parts of a playbook are executed.
```yaml
---
- name: Deploy Application
  hosts: all
  roles:
    - { role: common, tags: ['common'] }
    - { role: webserver, tags: ['webserver'] }
    - { role: database, tags: ['database'] }

  tasks:
    - name: Import additional common tasks
      import_tasks: standard_tasks.yml
      tags: standard_tasks

    - name: Import additional webserver tasks
      import_tasks: webserver_tasks.yml
      tags: webserver_tasks

    - name: Import additional database tasks
      import_tasks: database_tasks.yml
      tags: database_tasks
```

#### Example of imported standard tasks:
```yaml
---
- name: Install additional common utilities
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - htop
    - tree

- name: Configure timezone
  timezone:
    name: 'Etc/UTC'

- name: Set up NTP service
  apt:
    name: ntp
    state: present

- name: Start and enable NTP service
  service:
    name: ntp
    state: started
    enabled: yes

- name: Update system packages
  apt:
    upgrade: dist
```

#### To run a webserver deployment with its additional tasks, use:
```bash
ansible-playbook deploy_application.yml --tags "webserver,standard_tasks,webserver_tasks"
```

This version keeps all your examples but simplifies the wording and focuses on practical usage.

---
## Best Practice

| Best Practice Category | Guidelines |
|------------------------|------------|
| **Consistency** | - **Follow naming conventions:** Use clear prefixes like `install_`, `configure_`, `uninstall_`, or `deploy_` so tags are easy to understand. <br> - **Group related tasks:** Tag related tasks together (e.g., all database tasks with `data_setup`) to make running a group of tasks easier. |
| **Documentation** | - **Add comments:** Explain unclear tasks or roles with comments. <br> - **Create a tag reference document:** Maintain a separate list of all tags and their purpose for team consistency. <br> - **Follow tag usage guidelines:** Establish team rules for structuring and applying tags, including examples and scenarios. |
| **Avoid Overusing Tags** | - **Limit tags per task:** Use only 2-3 tags per task when necessary. <br> - **Use tags only when needed:** Not every task requires a tag; only tag tasks that may run independently. <br> - **Avoid redundant tags:** Ensure each tag is unique and avoid duplicates. <br> - **Review existing tags:** Periodically check tags to remove irrelevant or stale ones. |


| Best Practice Category | Guidelines | Good Tag Example | Bad Tag Example |
|------------------------|------------|-----------------|----------------|
| **Consistency** | - Follow naming conventions for clarity.<br>- Group related tasks under one tag. | `install_apache`, `configure_db` | `task1`, `setup` |
| **Documentation** | - Add comments explaining unclear tasks.<br>- Maintain a tag reference document.<br>- Follow team guidelines for tag usage. | `# Tag used to install web server`<br>`deploy_app` | No comments or scattered tag definitions |
| **Avoid Overusing Tags** | - Limit tags per task (2-3 max).<br>- Only tag tasks that can run independently.<br>- Avoid duplicate or redundant tags.<br>- Periodically review tags. | `install_web, webserver` | `install_web, setup_web, deploy_web` |
| **Reusability** | - Use tags to group tasks that might be reused in multiple scenarios.<br>- Make tags descriptive enough to indicate purpose. | `database_setup`, `webserver_tasks` | `misc_task`, `do_stuff` |
| **Control Execution** | - Use tags to run or skip tasks selectively without affecting other tasks.<br>- Combine with `--tags` or `--skip-tags` for precise control. | `ansible-playbook site.yml --tags "webserver"` | Running the full playbook every time without tags |

