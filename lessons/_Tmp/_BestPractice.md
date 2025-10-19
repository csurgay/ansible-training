
# Section xx: Ansible Best Practice

### In this section the following subjects will be covered

1. General Principles
1. Recommended Project Structure
1. Inventory Management
1. Playbooks and Task Design
1. Debug Practices
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
- Keep **consistent indentation** and spacing.  
- Write **clear comments** describing tasks.  
- Follow **consistent naming** for tasks, variables, roles, and files.  
- Store projects in **version control** (e.g., Git).  
- Use **ansible-lint** and **molecule** for linting and testing.  
- Use **tags** to organize and run specific tasks.  
- **Start simple** and expand gradually.

- YAML is easier to read and maintain than JSON. 
- Consistent indentation ensures files parse correctly and improves readability. 
- Comments clarify why tasks exist. 
- Naming conventions help you locate and understand tasks, variables, and roles. 
- Version control tracks changes and simplifies collaboration. 
- Linting and testing ensure reliability. 
- Tags help run only specific parts of a playbook. Starting simple reduces complexity and prevents errors.

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

To create a new role skeleton:

```bash
ansible-galaxy role init <role_name>
```

- Separate inventories per environment prevent mistakes. 
- Group and host variable directories organize configuration and reduce duplication. 
- Custom modules and plugins are stored in dedicated folders. 
- `site.yml` orchestrates smaller playbooks for modularity. 
- Roles include tasks, handlers, templates, files, variables, defaults, and metadata for reuse. 
- Using `ansible-galaxy role init` reduces setup errors.

---
## Inventory Management

Inventories define which hosts Ansible manages. Proper inventory practices ensure tasks run correctly.

- Group hosts logically (by function, environment, or location).  
- Keep separate inventories for each environment (`production`, `staging`).  
- Use **dynamic inventories** for cloud or changing environments.  
- Use **group_by** to create runtime groups.

Example:

```yaml
- name: Group by OS
  hosts: all
  tasks:
    - name: Create OS-based groups
      group_by:
        key: os_{{ ansible_facts['distribution'] }}
```

Conditional plays:

```yaml
- hosts: os_Ubuntu
  tasks:
    - debug:
        msg: "Ubuntu specific configuration"
```

- Logical grouping simplifies targeting tasks and ensures correct execution. 
- Separate inventory files avoid mistakes in multiple environments. 
- Dynamic inventories help manage changing hosts in cloud environments. 
- `group_by` dynamically assigns hosts to groups at runtime. 
- Conditional plays allow running tasks only on specific hosts, improving efficiency and reducing risk.

---
## Playbooks and Task Design

- Always **declare the desired state**.  
- Put **each argument on a separate line**.  
- Group related tasks with **blocks**.  
- Use **handlers** for triggered actions.  
- Use a top-level playbook (`site.yml`) to orchestrate smaller playbooks.

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

- Declaring states ensures tasks behave as expected. 
- Separate lines for arguments improve readability. 
- Blocks group related tasks, simplifying management and error handling. 
- Handlers run only when changes occur, improving efficiency. 
- Top-level playbooks provide orchestration and modularity.

---
## Debug Practicies

Regiser result of all tasks, then debug based on success.

```yaml
- name: Install EDB server packages
  dnf:
    name: "{{ item }}"
    state: present
  loop: "{{ edb_server_packages }}"
  register: result_install

- debug:
    var: result_install
  when: result_install is failed
```

---
## Variable Management

- Define **defaults** in `roles/<role>/defaults/main.yml`.  
- Use `group_vars` and `host_vars` directories.  
- Prefix variable names with role or context names to avoid conflicts.

Example:

```yaml
webserver_port: 8080
database_port: 5432
```

- Quote strings properly.  
- Keep variable logic simple.

- Defaults provide fallback values. 
- Group and host variables organize configuration per host or group. 
- Prefixing names prevents collisions. 
- Proper quoting ensures correct interpretation. 
- Simple variables reduce complexity and improve readability.

---
## Module Usage

- Place custom modules in `./library`.  
- Prefer **idempotent modules** over `shell` or `command`.  
- Always specify **state**.  
- Combine similar actions using lists.

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

- Custom modules in the library are automatically available. 
- Idempotent modules ensure safe repeatable operations. 
- Explicit states clarify intended behavior. 
- Using lists avoids repetitive code and improves readability.

---
## Roles

Roles group tasks, handlers, and variables into reusable components.

- Follow **Ansible Galaxy** structure.  
- Keep roles **focused** and loosely coupled.  
- Use **import_role** or **include_role** for execution control.  
- Validate and store external roles locally.

- Roles should perform one clear function. 
- Galaxy standards improve readability. 
- Loosely coupled roles are reusable. 
- Importing roles controls execution order. 
- Storing validated roles locally avoids dependency issues.

---
## Execution and Deployment

- Test in **staging** before production.  
- Limit execution using `--limit` or `--tags`.  
- Preview execution with `--list-tasks`, `--list-hosts`, `--check`, `--diff`.  
- Resume partial runs with `--start-at-task "<task name>"`.  
- Use `serial` for **rolling updates**.  
- Explore [execution strategies](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html).

- Testing in staging prevents production mistakes. 
- Limiting execution targets the desired hosts or tasks. 
- Previewing shows what would happen. 
- Rolling updates prevent downtime by updating hosts in batches. 
- Execution strategies optimize task performance in large deployments.

---
## Security Practices

- Use **Ansible Vault** or external secrets managers.  
- Limit `become` usage to necessary tasks.  
- Apply **RBAC** and governance controls.  
- Scan for vulnerabilities regularly.  
- Log and monitor executions centrally.

- Vault encrypts sensitive information. 
- Limiting privilege escalation reduces risk. 
- RBAC gives fine-grained access control. 
- Regular scans identify issues. 
- Logging and monitoring provide audit trails and help troubleshoot.

---
## Additional Notes

- Ensure **idempotency** across all tasks.  
- Use **role dependencies** carefully.  
- Integrate **dynamic inventories** for hybrid environments.  
- Combine provisioning and configuration when possible.

- Idempotent tasks are safe to run multiple times. 
- Careful role dependency management keeps roles modular. 
- Dynamic inventories simplify hybrid deployments. 
- Combining provisioning and configuration reduces complexity.

---
## References

- [Ansible Inventory Guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)  
- [Ansible Playbooks Guide](https://docs.ansible.com/ansible/latest/playbook_guide/index.html)  
- [Ansible Modules Reference](https://docs.ansible.com/ansible/latest/collections/index_module.html)  
- [Molecule Testing Framework](https://molecule.readthedocs.io/)  
- [Ansible Galaxy](https://galaxy.ansible.com/)  

