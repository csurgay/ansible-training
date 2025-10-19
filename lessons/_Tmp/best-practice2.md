# Section xx: Ansible Best Practice

### In this section the following subject will be covered

1. General Principles
1. Recommended Project Structure
1. Inventory Management
1. Playbooks and Task Design
1. Variable Management
1. Module Usage
1. Roles
1. Execution and Deployment
1. Security Practices
1. Additional Notes
1. References
   
---
## General Principles

- Use **YAML** instead of JSON for readability.
- Maintain **consistent indentation** and spacing.
- Write **clear comments** describing intent and effects.
- Use **consistent naming conventions** for tasks, variables, roles, and files.
- Keep projects **in version control** (Git).
- Use **ansible-lint** and **molecule** for linting and testing.
- Apply **tags** logically to organize and selectively run tasks.
- **Start simple** and expand with experience.

---
## Recommended Project Structure

```
inventory/
  production
  staging
  test

group_vars/
  web.yml
  db.yml

host_vars/
  web01.yml
  db01.yml

library/
module_utils/
filter_plugins/

site.yml
web.yml
db.yml

roles/
  webserver/
    tasks/main.yml
    handlers/main.yml
    templates/web.conf.j2
    files/setup.sh
    vars/main.yml
    defaults/main.yml
    meta/main.yml

  database/
    tasks/main.yml
    handlers/main.yml
```

To generate a role skeleton:

```bash
ansible-galaxy role init <role_name>
```

---
## Inventory Management

- Group hosts logically (by function, environment, location).
- Separate inventories per environment (e.g., `production`, `staging`).
- Use **dynamic inventories** for cloud integration.
- Use **group_by** for runtime grouping.

Example:

```yaml
- name: Group by OS
  hosts: all
  tasks:
    - name: Create OS-based groups
      group_by:
        key: os_{{ ansible_facts['distribution'] }}
```

Then use conditional plays:

```yaml
- hosts: os_Ubuntu
  tasks:
    - debug:
        msg: "Ubuntu specific configuration"
```

---
## Playbooks and Task Design

- Always **declare the desired state** explicitly.
- Use **one argument per line** for clarity.
- Group related tasks with **blocks**.
- Trigger follow-up actions with **handlers**.
- Keep top-level orchestration in a single playbook (`site.yml`) and **include/import** others.

Example task:

```yaml
- name: Create application user
  ansible.builtin.user:
    name: "{{ app_user }}"
    state: present
    uid: 1100
    generate_ssh_key: true
  become: true
```

Example block:

```yaml
- name: Install and configure web server
  block:
    - name: Update cache
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Deploy configuration
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
  when: ansible_facts['distribution'] == 'Ubuntu'
  tags: web
  become: true
```

Handler example:

```yaml
handlers:
  - name: Restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

---
## Variable Management

- Define **defaults** in `roles/<role>/defaults/main.yml`.
- Use `group_vars` and `host_vars` for clarity.
- Prefix variables with role or context names to avoid conflicts.

Example:

```yaml
webserver_port: 8080
database_port: 5432
```

- Quote strings properly.
- Avoid overcomplicating variable logic.

---
## Module Usage

- Place custom modules in `./library`.
- Prefer **idempotent** modules over `shell` or `command`.
- Always specify **state**.
- Combine similar actions in one module using lists.

Example:

```yaml
- name: Install packages
  ansible.builtin.apt:
    name:
      - curl
      - unzip
      - git
    state: latest
```

---
## Roles

- Follow **Ansible Galaxy** structure.
- Keep roles **focused** and **loosely coupled**.
- Use **import_role** or **include_role** for control.
- Validate and store external roles locally.

---
## Execution and Deployment

- Test in **staging** before production.
- Limit execution scope with `--limit` or `--tags`.
- Use preview options:
  - `--list-tasks`
  - `--list-hosts`
  - `--check`
  - `--diff`
- Resume partial runs with `--start-at-task "<task name>"`.
- Use `serial` for **rolling updates**.
- Explore [execution strategies](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html).

---
## Security Practices

- Use **Ansible Vault** or external secrets managers.
- Limit `become` usage to where necessary.
- Apply **RBAC** and governance controls.
- Scan for vulnerabilities regularly.
- Log and monitor Ansible executions centrally.

---
## Additional Notes

- Ensure **idempotency** across all tasks.
- Use **role dependencies** judiciously.
- Integrate **dynamic inventories** for hybrid setups.
- Combine provisioning and configuration when possible.

---
## References

- [Ansible Inventory Guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)  
- [Ansible Playbooks Guide](https://docs.ansible.com/ansible/latest/playbook_guide/index.html)  
- [Ansible Modules Reference](https://docs.ansible.com/ansible/latest/collections/index_module.html)  
- [Molecule Testing Framework](https://molecule.readthedocs.io/)  
- [Ansible Galaxy](https://galaxy.ansible.com/)  

