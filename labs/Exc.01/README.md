Exercise 1.  Provisioning the Training Lab
==========================================

In this exercise the following steps will be cerried out:
1.	Ansible control node and the managed hosts will be launched in containers
2.	SSH keys will be set up so that ansible can access managed hosts 
3.	Ansible will be installed and configured on the control node
4.	Ansible will be tested to access control nodes by ad-hoc commands

1.	Launching the Ansible Training Environment
Log into the builder environment
1.	Log in to the Ansible Training virtual machine called “builder” as root
2.	Install “git” if not already installed “dnf -y install git”
3.	Clone the Training Lab Git Repository to your local VM:
4.	git clone https://github.com/csurgay/ansible-training.git
5.	cd into the “ansible-training/labenv” directory in root’s home
Build ansible “control node” image
1.	cd into the “controlnode” directory under “labenv”
2.	Run the command “./build.sh”
3.	It is going to take some time, ca. 2-3 minutes
4.	Check the images with the command “podman images -a”
Run the “control node” container
1.	Run the command “./run.sh” in the same “controlnode” directory
2.	Check the running container with the command “podman ps -a”
Build ansible “managed host” image
1.	cd into the “managedhost” directory under “labenv”
2.	Run the command “./build.sh”
3.	Check the images with the command “podman images -a”
Run the “managed host” containers
1.	Run the command “./run.sh” in the same “managedhost” directory
2.	Check the output IP and MAC addresses, they should all be different
3.	Make note of the 3 IP addresses, we will need them later (e.g. 10.88.0.11, 12, 13)
4.	Check the running containers with the command “podman ps -a”

2.	Setting up SSH keys
Generate SSH keys on “controlnode”
1.	Enter control node with the command “podman exec -it ansible bash”
2.	Generate SSH keys with the command “ssh-keygen”
3.	Answer with empty “Enter” to all three questions
Copy public ssh keys into managed hosts
1.	Issue the command “ssh-copy-id 10.88.0.11”
2.	Answer “yes” for the known_host fingerprint related question
3.	Type in root password “root” when requested
4.	Repeat 2 and 3 for the other two magaged host containers as well

3.	Install and configure Ansible on control node
Install ansible and vim
1.	Run “dnf install -y ansible” on control node “ansible” host as root
2.	Test the installation with “ansible –version”
3.	Suppress the python version warning with the command:
4.	printf “[defaults]\ninterpreter_python=auto_silent\n” > ansible.cfg
5.	Install Vim editor for coloring of playbooks “dnf install -y vim”
Create inventory for the managed hosts
1.	Create a textfile named “inventory” with the three IP addresses e.g. as follows:
[servers]
10.88.0.11
10.88.0.12
10.88.0.13

4.	Test ansible access managed hosts
Ad-hoc command for testing
1.	Test that ansible can manage the hosts with the ping module as follows:
2.	ansible -i inventory servers -m ping
3.	Check ansible output for all three pong responses


