echo "Vault password is secret"

ansible-playbook -K --vault-id=@prompt users.yml

