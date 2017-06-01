#!/bin/bash

# Ask for hostname to apply baseline to
#read -p "On which host to add user ansible? " targetHost
#echo "User ansible going to be applied to : $targetHost"

#echo $targetHost > /etc/ansible/host.add-user-ansible

echo ..create user ansible
#ansible-playbook --inventory-file=/etc/ansible/host.add-user-ansible /home/pappam/ansible/playbooks/add-user-ansible.yml --ask-pass || exit 
ansible-playbook --limit=newhosts /home/pappam/playbooks/add-user-ansible.yml --ask-pass || exit

echo .. DONE ..
