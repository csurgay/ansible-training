```mermaid
flowchart LR
   ansible --> Id1(ansible config) --> inventory --> /etc/hosts --> ssh --> ssh_config --> sshd --> sshd_config --> PermitRootLogin --> python

