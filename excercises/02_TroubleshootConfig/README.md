```mermaid
flowchart TD
  subgraph id1[Ansible on control node]
    direction LR
    id11(ansible) --> id12(ansible.cfg) --> id13(inventory) --> id14(/etc/hosts)
  end
  subgraph id2[SSH on control node]
    direction LR
    id21(ssh) --> id22(ssh_config) --> id23(StrictHostkey)
  end
  subgraph id3[SSHD on managed host]
    direction LR
    id31(sshd) --> id32(sshd_config) --> id33(PermitRootLogin)
  end
  subgraph id4[Python on managed host]
    direction LR
    id41(python)
  end
  id1 --> id2
  id2 --> id3
  id3 --> id4
