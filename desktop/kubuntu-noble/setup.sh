#!/bin/bash

# Install Ansible and ssh
sudo apt -y update && sudo apt -y install ansible ssh

# Create temporaly ssh key pair
if [ ! -e .ssh]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi
sshkey=$(mktemp -p ~/.ssh)
rm $sshkey && ssh-keygen -f $sshkey -t ed25519 -N ""
cat ${sshkey}.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# configure sudoers
export sudoer=$(whoami)
sudo --preserve-env=sudoer sh -c 'echo "$sudoer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$sudoer'
unset sudoer

# Run ansible
## make playbook list
cd $(dirname $0)
for pbfile in $(find . -name "*.yml" | sort);
do
    ansible_args="$ansible_args $pbfile"
done
## Exec ansible-playbook
ansible-playbook --private-key="$sshkey" $ansible_args

# Clean-up
sed -i '$d' ~/.ssh/authorized_keys
rm ${sshkey}*