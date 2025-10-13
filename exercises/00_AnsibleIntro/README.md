# Section 1. Ansible Introduction

### In this section the following subjects will be covered:

1.	What is Ansible
2.	Ansible automation
3.	Advantages of Ansible
4.	Ansible concepts

---
# What is Ansible

Ansible is a tool that helps you automate and manage computers and systems across different platforms. It’s widely used by IT teams and has become a popular choice for large organizations that want to simplify and speed up their operations.

Supported by **Red Hat** and a strong open-source community, Ansible is great for **configuring systems, setting up infrastructure, and deploying applications**.

It can automate almost anything—from cloud and on-premise servers to IoT devices—making your IT environment **faster, more consistent, and more reliable**.

---
# Ansible automation

Ansible works using two types of machines: a **control node** and **managed nodes**. The control node is the computer where Ansible is installed. From there, it connects to the managed nodes and sends them commands and instructions.

The pieces of code that Ansible runs on managed nodes are called **modules**. Each module is triggered by a **task**, and a list of tasks forms a **playbook**. In a playbook, you describe what the system should look like or what actions should happen.

All managed machines are listed in a simple **inventory file**, which can group them into different categories.

Ansible uses **YAML**, an easy-to-read language, to define playbooks, so you can understand and write them from the very beginning.

One big advantage of Ansible is that it **doesn’t need any agent software** installed on the managed machines—making setup and use very straightforward.

In most cases, all you need is a **terminal** to run commands and a **text editor** to write your configuration files.

---
# Advantages of Ansible

* **Free and open-source**, supported by a large and active community.
* **Proven and reliable**, trusted by IT professionals for many years.
* **Easy to learn and use**, with no need for advanced programming skills.
* **Simple to set up**, since it doesn’t require any extra agents.
* **Flexible and modular**, with powerful features that grow with your experience.
* **Well-documented**, with official guides and plenty of helpful community resources online.

---
# Ansible Concepts
Here are the main ideas and terms you’ll come across when learning about Ansible:

* **Host:** A remote computer managed by Ansible
* **Group:** A set of hosts that share something in common
* **Inventory:** A list of all the hosts and groups that Ansible manages. It can be a simple static file or a dynamic list pulled from external sources like cloud providers
* **Module:** A small piece of code that Ansible runs on the remote machines to perform specific actions
* **Task:** A single action in Ansible that calls a module with certain options
* **Playbook:** A file that contains one or multiple Plays
* **Play:** A list of tasks, describing step-by-step how a system should be configured
* **Role:** A reusable and shareable way to organize playbooks, tasks, and files for easier automation
* **YAML:** A simple, human-friendly text format that Ansible uses to define playbooks and configuration files

---

