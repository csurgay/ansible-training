# vsftpd-role project

Convert vsftpd complex Playbook to a Role-based Playbook


## Copy vsftpd project as basis Role transformation

```bash
cd /home/devops/ansible-training/lessons/14-Roles/
cp -r vsftpd/ vsftpd-to-role
```

## Create empty role boilerplate directory structure

```bash
cd vsftpd-to-role
mkdir roles
cd roles
ansible-galaxy init vsftpd-role
cd ..
tree roles
```

## Place vars.yml into roles/vsftpd-role/vars directory as main.yml

```bash
mv vars/vars.yml roles/vsftpd-role/vars/main.yml
rmdir vars/
```

## Place template file into roles/vsftpd-role/template directory

```bash
mv templates/vsftpd.conf.j2 roles/vsftpd-role/templates/
rmdir templates/
```

## Place site.yml into roles/vasftpd/tasks directory as main.yml
mv site.yml roles/vsftpd-role/tasks/main.yml

## Place the included Playbook yaml files also into roles/vsftpd/tasks/
mv vsftpd.yml ftpclients.yml roles/vsftpd-role/tasks/

## Create test as roles/vsftpd-role/tests/main.yml

```yaml
---
- name: Smoke test of vsftpd-to-role project
  hosts: host3
  become: false
  gather_facts: false

  roles:
    - vsftpd-role

  tasks:
    
    - name: Test lftp from host3 to host2
      ansible.builtin.shell:
        cmd: |
          lftp -u devops,devops host2<<EOF
          cd /tmp
          put /etc/hosts
          bye
          EOF
      register: result_lftp

    - name: Print lftp result
      ansible.builtin.debug:
        msg: "{{ result_lftp.stdout }}"
```

## Move the handler from vsftpd.yml into roles/vsftpd-role/handlers/main.yml

```yaml
---
# handlers file for vsftpd-role
- name: restart vsftpd
  ansible.builtin.service:
    name: "{{ vsftpd_service }}"
    state: restarted
```

## Complete meta info in roles/vasftpd-role/meta/main.yml

```yaml
galaxy_info:
  author: Ansible Training
  description: Role to set up ftp servers and clients, and testing
  company: Good company :)
```


