# Section xx: Ansible Best Practice

### In this section the following subjects will be covered.

1. Use YAML over JSON: YAML is more readable and idiomatic in Ansible.  
1. Maintain consistent indentation and spacing: Leave blank lines between tasks or sections to improve readability.  
1. Add comments: Explain the purpose of plays, tasks, and variables.  
1. Adopt a consistent naming convention: Name all tasks, variables, roles, and files consistently.  
1. Define a style guide: Encourage uniform conventions across the team.  
1. Keep it simple: Start small with static inventories and simple playbooks; expand gradually.  
1. Store in version control: Keep your Ansible code in Git or another VCS. Commit changes regularly.  
1. Use linting and testing: Tools such as `ansible-lint` and `molecule` help ensure code quality.  
1. Tag consistently: Use tags to organize and selectively run tasks.

### Example Directory Layout

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
web_tier.yml
db_tier.yml

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

Use `ansible-galaxy role init <role_name>` to generate a standardized role skeleton.

---

## 2. Inventory Best Practices

- **Group hosts logically:** Organize by function, environment, or location.  
- **Separate inventories per environment:** For example, `production`, `staging`, and `test`.  
- **Use dynamic inventories:** Integrate with cloud APIs for automatic host discovery.  
- **Use runtime grouping:** Group hosts dynamically using the `group_by` module.

Example:

```yaml
- name: Group hosts by operating system
  hosts: all
  tasks:
    - name: Create OS-based groups
      group_by:
        key: os_{{ ansible_facts['distribution'] }}

- hosts: os_Ubuntu
  tasks:
    - name: Ubuntu-specific configuration
      debug:
        msg: "Running on Ubuntu"

- hosts: os_RedHat
  tasks:
    - name: RedHat-specific configuration
      debug:
        msg: "Running on RedHat"
```

**Tip:** You can combine provisioning and configuration by exporting your IaC-generated inventory directly to Ansible.

---

## 3. Plays and Playbooks Best Practices

- **Always specify the desired state:** Be explicit about what each task should do.  
- **Use one argument per line:** This improves readability and diffs.  
- **Create top-level orchestration playbooks:** Import or include smaller, focused playbooks.  
- **Use blocks to group related tasks:** Enables shared conditions and easier rollbacks.  
- **Use handlers for triggered actions:** Handlers should only run when a change occurs.

Example (readable formatting):

```yaml
- name: Create application user
  ansible.builtin.user:
    name: "{{ app_user }}"
    state: present
    uid: 1100
    generate_ssh_key: true
  become: true
```

Example using `block`:

```yaml
- name: Install and configure web server
  block:
    - name: Update package cache
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Copy nginx configuration
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
  when: ansible_facts['distribution'] == 'Ubuntu'
  tags: web
  become: true
```

Example handler:

```yaml
handlers:
  - name: Restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

---

## 4. Variables Best Practices

- **Provide sensible defaults:** Use `group_vars/all` or `roles/<role>/defaults/main.yml`.  
- **Use `group_vars` and `host_vars`:** Keep inventories concise and maintainable.  
- **Prefix variables with the role name:** Avoid naming conflicts.

Example:

```yaml
webserver_port: 8080
database_port: 5432
```

- **Keep variable usage simple:** Avoid unnecessary complexity.  
- **Quote values correctly:** Use double quotes for strings and single quotes for literals.

---

## 5. Modules Best Practices

- **Keep local modules near playbooks:** Place custom modules in the `./library` directory.  
- **Avoid using `command` or `shell`:** Prefer idempotent built-in modules.  
- **Be explicit:** Include key arguments like `state`.  
- **Use lists for similar actions:** Group related items into one module call instead of looping.

Example:

```yaml
- name: Install common packages
  ansible.builtin.apt:
    name:
      - curl
      - unzip
      - git
    state: latest
```

- **Document and test custom modules:** Include examples, dependencies, and expected return data.

---

## 6. Roles Best Practices

- **Follow Galaxy structure:** Use `ansible-galaxy init` for consistent layout.  
- **Keep roles single-purpose:** Each role should manage one area of responsibility.  
- **Minimize dependencies:** Keep roles loosely coupled.  
- **Use `import_role` or `include_role`:** Control execution order explicitly.  
- **Validate external roles:** Only use trusted roles from Ansible Galaxy.  
- **Store downloaded roles locally:** Avoid relying on external availability.

---

## 7. Execution and Deployment Best Practices

- **Test in staging first:** Always validate changes before applying to production.  
- **Limit scope intentionally:**  
  - Use `--limit` to restrict hosts.  
  - Use `--tags` to run specific tasks.  
- **Preview execution:**  
  - `--list-tasks` – list tasks without running them  
  - `--list-hosts` – show affected hosts  
  - `--check` – perform a dry run  
  - `--diff` – show file changes  
- **Resume partially completed runs:** Use `--start-at-task "<task name>"`.  
- **Control concurrency:** Use the `serial` keyword for rolling updates.  
- **Adjust execution strategy:** See [Ansible execution strategies](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html) for alternatives.

---

## 8. Security Best Practices

- **Do not store secrets in plain text:** Use **Ansible Vault** or an external secrets manager.  
- **Limit privilege escalation:** Use `become: true` only when necessary.  
- **Implement RBAC:** Apply role-based access control to manage privileges.  
- **Governance and policy enforcement:** Define rules (e.g., via OPA) to restrict risky actions.  
- **Scan for vulnerabilities:** Integrate scanning tools into CI/CD pipelines.  
- **Implement observability:** Track host activity and playbook runs centrally.

---

## 9. Additional Recommendations

- Ensure playbooks are **idempotent**.  
- Use **role dependencies** thoughtfully to promote modularity.  
- Combine **provisioning and configuration** when possible.  
- Leverage **dynamic inventories** for cloud and hybrid environments.

---

## 10. References

- [Ansible Inventory Guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)  
- [Ansible Playbooks Guide](https://docs.ansible.com/ansible/latest/playbook_guide/index.html)  
- [Ansible Modules Reference](https://docs.ansible.com/ansible/latest/collections/index_module.html)  
- [Molecule Testing Framework](https://molecule.readthedocs.io/)  
- [Ansible Galaxy](https://galaxy.ansible.com/)  
