#!/bin/bash

NFS_DIR=/srv/kubedata
FABRIC_FILES_PATH=$NFS_DIR/fabricfiles
BROKER_PATH=$NFS_DIR/fabricfiles/broker

# Functions #########################################################################

function create_fabricfiles_dir(){
echo "## Created fabric files path"    
echo
sudo mkdir $FABRIC_FILES_PATH
sudo chown -R nobody:nogroup $FABRIC_FILES_PATH
sudo chmod -R 777 $FABRIC_FILES_PATH
}


function create_broker_dir(){
echo "## Created broker path"    
echo
sudo mkdir -p $BROKER_PATH
sudo mkdir $BROKER_PATH/zookeeper0
sudo mkdir $BROKER_PATH/zookeeper1
sudo mkdir $BROKER_PATH/kafka0
sudo mkdir $BROKER_PATH/kafka1
sudo chmod -R 777 $BROKER_PATH
}

# Let's go ###################################################################################
create_fabricfiles_dir
create_broker_dir
