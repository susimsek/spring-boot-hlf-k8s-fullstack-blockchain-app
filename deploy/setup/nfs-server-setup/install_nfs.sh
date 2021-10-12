#!/bin/bash

# install nfs server


# get some variables #####################################################################

IP_RANGE=$(dig +short k8smaster | grep -v 127.0 | sed s/".[0-9]*$"/.0/g)

NFS_PATH=/srv/kubedata


# Functions #####################################################################


prepare_directories(){
sudo mkdir -p ${NFS_PATH}
sudo chmod 777 -R ${NFS_PATH}
}

install_nfs(){

sudo apt-get install -y nfs-kernel-server 2>&1 > /dev/null

}

set_nfs(){
sudo echo "${NFS_PATH} ${IP_RANGE}/24(rw,sync,no_root_squash,no_subtree_check)">/etc/exports
}

run_nfs(){
sudo systemctl restart nfs-server rpcbind
sudo exportfs -a
}

# Let's go #######################################################################
prepare_directories
install_nfs
set_nfs
run_nfs