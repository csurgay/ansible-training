# Section 12. Control Flow

### In this section the following subjects will be covered:

1. Conditions

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
