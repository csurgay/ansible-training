# Exercise 2. Troubleshooting Ansible Configuration

### In this exercise the following steps will be cerried out:

1. Participants are instructed to form group of pairs
2. One member shall introduce some failure to the Ansible configuration
3. Failures can affect any of the boxes on the Figure below
4. The other member shall try to localize and fix the failure introduced
5. The first member observes the process and helps with hints if neccessary
6. They test Ansible successfully access managed hosts together
7. Members of the pair swith roles and do the excercise again

## Figure 1. Validation process for Ansible configuration

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
```

## Validation steps for Ansible configuration

| Failure point | Description | Test | Fix |
|---------------|-------------|------|-----|
| **Ansible** | Ansible is installed on Control node | **`ansible --version`** | **`dnf install -y ansible`** |
| **ansible.cfg** | Ansible is installed on Control node | **`ansible --version`** | **`dnf install -y ansible`** |

