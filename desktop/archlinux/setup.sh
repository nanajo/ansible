#!/bin/bash

export ANSIBLE_LIBRARY="$HOME/.ansible/plugins/modules/:/usr/share/ansible/plugins/modules/"
sudo pacman -S ansible openssh
sudo systemctl start sshd
ansible-galaxy  collection install kewlfft.aur
#mkdir -p ~/.ansible/plugins/modules/
#curl -o ~/.ansible/plugins/modules/aur.py https://raw.githubusercontent.com/kewlfft/ansible-aur/master/plugins/modules/aur.py

ansible-playbook master.yml