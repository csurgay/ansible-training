# Section 11. Vault

---
### In this section the following subjects will be covered

1. Introduction to Secrets
1. Vault Usage

---
### Introduction to Secrets

Automation tasks require credentials. Passwords, SSH and API keys, tokens need to be used on the 
Managed Hosts for resources to be managed. These cannot be stored in plain text in Ansible scripts or 
other text files for obvious security reasons.

Ansible Vault is a simple encryption automatism for all the above scenarios that stores sensitive data in 
encripted textfiles with master password for Ansible to automatically decrypt on demand. Vault can handle 
variables (sttuctured Ansible data in textual yaml format) and data files.

---
### Vault Usage

`ansible-vault create mysecrets.yml`

command will ask for a master password and open the text editor for the strucrtured data to be encrypted.

`mysecrets.yml`
```
---
# Secrets to be encrypted by Vault
username: local
password: local
```

`ansible-vault encrypt mysecret.yml`
`ansible-vault view mysecret.yml`
`ansible-vault decrypt mysecret.yml`

Master password for Vault can be stored in a textfile too, with appropriate access control of course.

```
echo vaultmasterpass > vault-pass.yml
ansible-vault view --vault-password-file=vault-pass.yml mysecret.yml
```

In Playbook the variables from Vault can be used as usual.

```
- name: Vault Variable illustration
  hosts: host1
  gather_facts: false
  tasks:
    - name: Print encrypted variables from Vault
      ansible.builtin.debug:
        var:
          username
          password
```
