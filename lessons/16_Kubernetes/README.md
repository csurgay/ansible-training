# Section 16: Kubernetes in Ansible

### In this section the following subject will be covered

1. Setup
1. Namespaces
1. Pods
1. Testing


---
## Setup

```bash
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.kubernetes
ansible-galaxy collection install cloud.common

sudo dnf install python3-pip
pip install kubernetes
```

---
## Namespaces

```yaml
---
- name: Create Kubernetes namespace
  hosts: all

  tasks:
    - name: Create k8s namespace
      kubernetes.core.k8s:
        api_version: v1
        kind: Namespace
        name: "MyNamespace"
        state: present
```

#### Alternative creation from manifest

```yaml
- name: Create a Namespace from K8S YAML File
  kubernetes.core.k8s:
    state: present
    src: /kube_manifests/create_namespace.yml
```

---
## Pods

```yaml
---
- name: Kubernetes pod deployment
  hosts: all
  vars:
    my_namespace: "MyNamespece"

  tasks:
    - name: Create k8s namespace
      kubernetes.core.k8s:
        api_version: v1
        kind: Namespace
        name: "{{ my_namespace }}"
        state: present

    - name: Create k8s pod
      kubernetes.core.k8s:
        namespace: "{{ my_namespace }}"
        state: present
        definition:
          apiVersion: v1
          kind: Pod
          metadata:
            name: nginx
          spec:
            containers:
              - name: nginx
                image: nginx:latest
                ports:
          - containerPort: 80
```

---
## Testing

```yaml
---
- name: Test playbook
  hosts: all
  gather_facts: false

  tasks:
    - name: Print message
      ansible.builtin.debug:
        msg: "Kubernetes Ansible Automation"
```

