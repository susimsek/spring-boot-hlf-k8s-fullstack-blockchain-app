#!/bin/bash

# Variables ########################################


# Functions ########################################

prepare_k8s_node(){
sudo apt update -qq 2>&1 >/dev/null
sudo apt install -y -qq git w3m sipcalc vim tree net-tools telnet git python3-pip sshpass nfs-common 2>&1 >/dev/null
sudo echo "autocmd filetype yaml setlocal ai ts=2 sw=2 et" > /home/vagrant/.vimrc
}

prepare_ssh(){
  sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
}

# Let's Go!! ########################################
prepare_k8s_node
prepare_ssh